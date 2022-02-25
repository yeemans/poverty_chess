class Pawn 
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end

  def on_start_square?()
    return true if self.color == "black" && self.row == 6
    return true if self.color == "white" && self.row == 1
    return false
  end

  def white_moves(board)
    square = self.row * 8 + self.column
    self.white_captures(board)

    return self.moves if Piece.hit_piece(board, square + 8) # can't move when pawn is blocked
    self.moves.push(square + 8)
    if self.on_start_square? && !Piece.hit_piece(board, square + 16)
      self.moves.push(square + 16) 
    end
    
    return self.moves
  end

  def white_captures(board)
    diag_left = self.row * 8 + self.column + 7
    diag_right = self.row * 8 + self.column + 9

    if in_bounds?(diag_left)
      square = board.get_square(diag_left)
        if Piece.hit_piece(board, diag_left) && !Piece.same_color?(self, square)
        self.moves.push(self.row * 8 + self.column + 7) if self.column != 0
      end
    end

    if in_bounds?(diag_right) 
      square = board.get_square(diag_right)
      if Piece.hit_piece(board, diag_right) && !Piece.same_color?(self, square) 
        self.moves.push(self.row * 8 + self.column + 9) if self.column != 7
      end
    end 
    return [diag_left, diag_right]
  end

  def black_moves(board)
    square = self.row * 8 + self.column 
    self.moves = self.moves.select { |m| m <= square } # erase the pawn's past moves, so it can't move backward
    self.black_captures(board)

    return self.moves if Piece.hit_piece(board, square - 8)
    self.moves.push(square - 8)
    if self.on_start_square?
      self.moves.push(square - 16) if !Piece.hit_piece(board, square - 16)
    end
    
    return self.moves
  end

  def in_bounds?(square)
    return true if square >= 0 && square <= 63
    return false
  end

  def black_captures(board)
    diag_right = self.row * 8 + self.column - 7
    diag_left = self.row * 8 + self.column - 9

    if in_bounds?(diag_right)
      square = board.get_square(diag_right)
      if Piece.hit_piece(board, diag_right) && !Piece.same_color?(self, square)
        self.moves.push(diag_right) if self.column != 7
      end
    end

    if in_bounds?(diag_left)
      square = board.get_square(diag_left)
      if Piece.hit_piece(board, diag_left) && !Piece.same_color?(self, square) 
        self.moves.push(diag_left) if self.column != 0
      end
    end 
    
    return [diag_left, diag_right]
  end

  def can_passant(board)
    last_move = board.move_list.last
    return false if !last_move
    return false if last_move[:piece] != "Pawn" || last_move[:color] == self.color 

    # check for white pawn moving to row 3, black pawn moving to row 4
    if last_move[:color] == 'white'
      # make sure the pawn moves two squares foward, not one
      return false unless last_move[:move] == last_move[:from_square] + 16
      return false unless last_move[:move].between?(24, 31)
    elsif last_move[:color] == 'black'
      return false unless last_move[:move] == last_move[:from_square] - 16
      return false unless last_move[:move].between?(32, 39)
    end 
    
    # previously moved pawn needs to be next to self 
    self_square = self.row * 8 + self.column
    return false if (last_move[:move] - self_square).abs != 1

    return true
  end 

  def black_en_passant(board)
    return unless self.can_passant(board) 
    p "moving"
    last_move = board.move_list.last 
    self_square = self.row * 8 + self.column
    # make sure we have a black pawn on the 4th row on the left or right
    self.moves.push(self.row * 8 + self.column - 7) if last_move[:move] > self_square
    self.moves.push(self.row * 8 + self.column - 9) if last_move[:move] < self_square
  end

  def white_en_passant(board)
    return unless self.can_passant(board) 
    last_move = board.move_list.last 
    self_square = self.row * 8 + self.column
    # make sure we have a black pawn on the 4th row on the left or right
    self.moves.push(self.row * 8 + self.column + 7) if last_move[:move] < self_square
    self.moves.push(self.row * 8 + self.column + 9) if last_move[:move] > self_square
  end


  def black_enpassant_capture(move, board) 
    move_to_square = board.cells[move]
    board.cells[move + 8] = "#" if move_to_square == "#" 
  end 

  def white_enpassant_capture(move, board)
    move_to_square = board.cells[move]
    board.cells[move - 8] = "#" if move_to_square == "#" 
  end
  
  def get_moves(board)

    self.white_moves(board) if self.color == "white"
    self.white_en_passant(board) if self.color == "white"

    self.black_moves(board) if self.color == "black"
    self.black_en_passant(board) if self.color == "black"

    self.moves = self.moves.uniq
  end

  def can_promote
    return true if self.color == "white" && self.row == 7 
    return true if self.color == "black" && self.row == 0 
    return false
  end

  def promotion(board)
    return unless self.can_promote 
    self.black_promote(board) if self.color == "black"  
    self.white_promote(board) if self.color == "white"
  end

  def get_promotion_choice(promotion_options, board)
    promotion_options.each_with_index { |option, index| p "#{index}: #{option.char}" } 
    puts "Type the number of the piece you want to promote to (0 -3)"
    promoted_pawn = promotion_options[gets.chomp.to_i]
    board.place_piece(promoted_pawn)
  end

  def black_promote(board)
    promotion_options = [
      Queen.new("♕", "black", [], self.column, self.row),
      Knight.new("♘", "black", [], self.column, self.row),
      Rook.new("♖", "black", [], self.column, self.row),
      Bishop.new("♗", "black", [], self.column, self.row)
    ]
    self.get_promotion_choice(promotion_options, board)
  end  

  def white_promote(board)
    promotion_options = [
      Queen.new("♛", "white", [], self.column, self.row),
      Knight.new("♞", "white", [], self.column, self.row),
      Rook.new("♜", "white", [], self.column, self.row),
      Bishop.new("♝", "white", [], self.column, self.row)
    ]
    self.get_promotion_choice(promotion_options, board)
  end
end