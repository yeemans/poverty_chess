require_relative 'piece.rb'

class Board 
  attr_accessor :cells
  attr_accessor :move_list

  def initialize(cells, move_list)
    @cells = cells
    @move_list = move_list
  end

  def get_square(index)
    return self.cells[index]
  end

  def place_piece(piece)
    square = piece.row * 8 + piece.column
    self.cells[square] = piece
  end

  def draw 
    files = ["a", "b", "c", "d", "e", "f", "g", "h"]
    print("1 ")

    cells.each.with_index(1) do |cell, index| 
      cell == "#" ? (print "# ") : (print "#{cell.char} ")
      if index % 8 == 0 && index < 64
        print "\n"
        print "#{index / 8 + 1} " # rank numbers
      end
    end

    print "\n  "
    files.each {|file| print "#{file} "} # file numbers
    print "\n\n"
  end

  def copy_cells 
    cells = []
    self.cells.each { |cell| cells.push(cell)}
    return cells
  end

  def white_move_list 
    moves = []
    self.move_list.each {|m| moves.push(m[:move]) if m[:color] == "white"}
    return moves
  end

  def black_move_list 
    moves = []
    self.move_list.each {|m| moves.push(m[:move]) if m[:color] == "black"}
    return moves
  end


end


