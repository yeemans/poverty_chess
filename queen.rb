class Queen  
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end 

  def get_moves(board)
    # queen moves are a combination of bishop and rook moves
    bishop = Bishop.new("B", self.color, [], self.column, self.row)
    rook = Rook.new("R", self.color, [], self.column, self.row)
    return bishop.get_moves(board).push(rook.get_moves(board)).flatten
  end
end