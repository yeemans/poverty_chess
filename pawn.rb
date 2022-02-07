class Pawn 
  attr_accessor :char, :color, :moves, :column, :row, :can_passant
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
    @can_passant = false
  end

  def on_start_square?()
    return true if self.color == "black" && self.row == 6
    return true if self.color == "white" && self.row == 1
    return false
  end

  def white_moves(board)
    square = self.row * 8 + self.column
    white_captures(board)

    return self.moves if Piece.hit_piece(board, square + 8) 
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
        self.moves.push(self.row * 8 + self.column + 7) if self.column != 7
      end
    end

    if in_bounds?(diag_right) 
      square = board.get_square(diag_right)
      if Piece.hit_piece(board, diag_right) && !Piece.same_color?(self, square) 
        self.moves.push(self.row * 8 + self.column + 9) if self.column != 0
      end
    end 
    return [diag_left, diag_right]
  end

  def black_moves(board)
    square = self.row * 8 + self.column 

    black_captures(board)
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
        self.moves.push(diag_right) if self.column != 0
      end
    end

    if in_bounds?(diag_left)
      square = board.get_square(diag_left)
      if Piece.hit_piece(board, diag_left) && !Piece.same_color?(self, square) 
        self.moves.push(diag_left) if self.column != 7
      end
    end 
    
    return [diag_left, diag_right]
  end

  def get_moves(board)
    self.moves = []
    self.moves =  self.white_moves(board) if self.color == "white"
    self.moves = self.black_moves(board) if self.color == "black"
    return self.moves
  end

end