require_relative 'piece.rb'

class Board 
  attr_accessor :cells

  def initialize(cells)
    @cells = cells
  end

  def get_square(index)
    return self.cells[index]
  end

  def place_piece(piece)
    square = piece.row * 8 + piece.column
    self.cells[square] = piece
  end

  def draw 
    cells.each.with_index(1) do |cell, index| 
      cell == "#" ? (print "#") : (print cell.char)
      print(" ")
      print "\n" if index % 8 == 0 
    end
  end

end


def hit_piece(board, index)
  return board.get_square(index) != "#"
end

def same_color(piece1, piece2)
  return piece1.color == piece2.color
end



board = Board.new([]) 
board.cells.push('#') while board.cells.count < 64

bishop = Bishop.new("♗", "white", [], 3, 3)
board.place_piece(bishop)

bishop2 = Bishop.new("♗", "black", [], 5, 1)
board.place_piece(bishop2)

bishop.moves = bishop.get_moves(board)
board.draw
p bishop

