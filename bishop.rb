class Bishop
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end

  def upright(board)
    # squares in the upright diagonal decrease in multiples of 7 
    board_edges = [7, 15, 23, 31, 39, 47, 55, 63]
    bishop_square = self.row * 8 + column
    return self.moves if bishop_square <= 7  
    (bishop_square - 7..0).step(-7).each do |square|
      if hit_piece(board, square)
        self.moves.push(square) if !same_color(self, board.get_square(square))
        break
      else 
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def upleft(board)
    # squares in the upleft diagonal decrease in multiples of 9
    board_edges = [0, 8, 16, 24, 32, 40, 48, 56]
    bishop_square = self.row * 8 + column
    return self.moves if bishop_square <= 7  
    (bishop_square - 9..0).step(-9).each do |square|
      if hit_piece(board, square)
        self.moves.push(square) if !same_color(self, board.get_square(square))
        break
      else 
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def get_moves(board)
    upright(board)
    upleft(board)
    #downright(board)
    #downleft(board)
    return self.moves
  end
end