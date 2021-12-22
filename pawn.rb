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
    return true if self.color == "black" && self.row == 1
    return true if self.color == "white" && self.row == 6
    return false
  end

  def white_moves(board)
    square = self.row * 8 + self.column
    if hit_piece(board, square - 8)
      return self.moves   
    else   
      self.moves.push(square - 8)
    end
    if self.on_start_square? && !hit_piece(board, square - 16)
      self.moves.push(square - 16) 
    end
    
    white_captures(board)
    return self.moves
  end

  def white_captures(board)
    diag_right = self.row * 8 + self.column - 7
    diag_left = self.row * 8 + self.column - 9

    square = board.get_square(diag_right)
    if hit_piece(board, diag_right) && !same_color(self, square)
      self.moves.push(self.row * 8 + self.column - 7)
    end

    square = board.get_square(diag_left)
    if hit_piece(board, diag_left) && !same_color(self, square) 
      self.moves.push(self.row * 8 + self.column - 9)
    end 
    return self.moves
  end

  def black_moves(board)
    square = self.row * 8 + self.column 
    if hit_piece(board, square + 8)
      return self.moves 
    else
      self.moves.push(square + 8)
    end

    if self.on_start_square?
      self.moves.push(square + 16) if !hit_piece(board, square + 16)
    end

    black_captures(board)
    return self.moves
  end

  def black_captures(board)
    diag_right = self.row * 8 + self.column + 7
    diag_left = self.row * 8 + self.column + 9

    square = board.get_square(diag_right)
    if hit_piece(board, diag_right) && !same_color(self, square)
      self.moves.push(self.row * 8 + self.column + 7)
    end

    square = board.get_square(diag_left)
    if hit_piece(board, diag_left) && !same_color(self, square) 
      self.moves.push(self.row * 8 + self.column + 9)
    end 
    return self.moves
  end

end