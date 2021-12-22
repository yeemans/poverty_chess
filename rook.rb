class Rook 
  attr_accessor :char, :color, :moves, :column, :row, :has_moved
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
    @has_moved = false
  end

  def right_moves(board)
    # moves to right of rook
    (self.column + 1..7).each do |column| 
      square = self.row * 8 + column
      # check if rook bumps into enemy piece, or ally piece 
      if hit_piece(board, square)
        piece = board.get_square(square)  
        self.moves.push(square) if !same_color(self, piece) 
        break # end the loop, since rook hits a piece
      else     
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def left_moves(board)
    (self.column - 1..0).step(-1).each do |column| 
      square = self.row * 8 + column
      # check if rook bumps into enemy piece, or ally piece 
      if hit_piece(board, square)
        piece = board.get_square(square)  
        self.moves.push(square) if !same_color(self, piece) 
        break # end the loop, since rook hits a piece
      else     
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def up_moves(board)
    (self.row - 1..0).step(-1).each do |row| 
      square = row * 8 + self.column
      # check if rook bumps into enemy piece, or ally piece 
      if hit_piece(board, square)
        piece = board.get_square(square)  
        self.moves.push(square) if !same_color(self, piece) 
        break # end the loop, since rook hits a piece
      else     
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def down_moves(board)
    (self.row + 1..7).each do |row| 
      square = row * 8 + self.column
      # check if rook bumps into enemy piece, or ally piece 
      if hit_piece(board, square)
        piece = board.get_square(square)  
        self.moves.push(square) if !same_color(self, piece) 
        break # end the loop, since rook hits a piece
      else     
        self.moves.push(square)
      end
    end
    return self.moves
  end

  def get_moves(board)
    up_moves(board)
    right_moves(board)
    down_moves(board)
    left_moves(board)
  end
end