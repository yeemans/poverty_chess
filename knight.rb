class Knight
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end

  def in_bounds?(coords)
    return false if coords[0] < 0 || coords[1] < 0
    return false if coords[0] > 7 || coords[1] > 7 
    return true
  end

  def on_board?(square)
    return true if square >= 0 && square <= 63
  end

  def get_moves(board) 
    moves = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]

    moves.each do |move|
      # calculate what number square this move would land on
      square = move[1] * 8 + move[0] + self.column + self.row * 8
      coordinates = [self.column + move[0], self.row + move[1]]

      if self.on_board?(square) && self.in_bounds?(coordinates)
        if Piece.hit_piece(board, square)
          self.moves.push(square) if !Piece.same_color?(self, board.get_square(square))
          next
        end 
        self.moves.push(square) 
      end
    end
    return self.moves
  end
end