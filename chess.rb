require_relative "board.rb"

board = Board.new([]) 
board.cells.push('#') while board.cells.count < 64

# pawns
(0..7).each do |column| 
  pawn = Pawn.new("♙", "black", [], column, 6)
  board.place_piece(pawn)
  #pawn = Pawn.new("♟", "white", [], column, 1)
  #board.place_piece(pawn)
end

# white pieces 
rook = Rook.new("♜", "white", [], 0, 0)
board.place_piece(rook)
rook = Rook.new("♜", "white", [], 7, 0)
board.place_piece(rook) 

#knight = Knight.new("♞", "white", [], 1, 0)
#board.place_piece(knight)
knight = Knight.new("♞", "white", [], 6, 0)
board.place_piece(knight)

bishop = Bishop.new("♝", "white", [], 2, 0)
#board.place_piece(bishop)
bishop = Bishop.new("♝", "white", [], 5, 0)
board.place_piece(bishop)

#queen = Queen.new("♛", "white", [], 3, 0)
#board.place_piece(queen)

white_king = King.new("♚", "white", [], 4, 0)
board.place_piece(white_king)

# black pieces 
rook = Rook.new("♖", "black", [], 0, 7)
board.place_piece(rook)
rook = Rook.new("♖", "black", [], 7, 7)
board.place_piece(rook) 

knight = Knight.new("♘", "black", [], 1, 7)
board.place_piece(knight)
knight = Knight.new("♘", "black", [], 6, 7)
board.place_piece(knight)

bishop = Bishop.new("♗", "black", [], 2, 7)
board.place_piece(bishop)
bishop = Bishop.new("♗", "black", [], 5, 7)
board.place_piece(bishop)

queen = Queen.new("♕", "black", [], 3, 7)
board.place_piece(queen)

king = King.new("♔", "black", [], 4, 7)
board.place_piece(king)

def checkmate?(board, turn)
  turn % 2 == 0 ? (color = "black") : (color = "white")
  board.cells.each do |cell| 
    return false if cell != "#" && cell.color == color && !cell.moves.empty?
  end

  return true
end

# testing
rook = Rook.new("R", "black", [], 3, 6)
board.place_piece(rook)
Piece.find_moves(board, 1)

def chess(board, turn, king)
  
  return if checkmate?(board, turn)
  board.draw
  Piece.find_moves(board, turn)
  Piece.display_pieces(board, turn)

  # testing
  p king.in_check?(board)
  p board.cells[11]
  # -----

  Piece.move(board, turn)
  chess(board, turn + 1, king)
end

chess(board, 1, white_king) # add king for testing purposes
