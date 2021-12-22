class Knight
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end

  def get_moves(board) 
    moves = [-15, -17, -6, -10, 6, 10, 15, 17]
    moves.each do |move|
      square = self.row * 8 + self.column + move
      if hit_piece(board, square)
        self.moves.push(square) if !same_color(self, board.get_square(square))
      else   
        self.moves.push(square)
      end
    end
    return self.moves
  end
end