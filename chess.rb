require_relative "board.rb"

def checkmate_slash_stalemate?(board, turn)
  turn % 2 == 0 ? (pieces = Piece.black_pieces(board)) : (pieces = Piece.white_pieces(board))
  return pieces.empty?
end

def indices_match?(array, indices)
  indices.each {|i| return false unless array[indices[0]] == array[i]} 
  return true
end

def threefold_repetition?(board)
  black_moves = board.black_move_list.last(5)
  white_moves = board.white_move_list.last(5)

  return if black_moves.count < 5 || white_moves.count < 5 

  return false unless indices_match?(black_moves, [0, 2, 4]) && indices_match?(black_moves, [1, 3])
  return false unless indices_match?(white_moves, [0, 2, 4]) && indices_match?(white_moves, [1, 3])
  return true
end

board = Board.new([], []) 
board.cells.push('#') while board.cells.count < 64

# pawns
(0..7).each do |column| 
  pawn = Pawn.new("♙", "black", [], column, 6)
  board.place_piece(pawn)
  pawn = Pawn.new("♟", "white", [], column, 1)
  board.place_piece(pawn)
end

# white pieces 
rook = Rook.new("♜", "white", [], 0, 0)
board.place_piece(rook)
rook = Rook.new("♜", "white", [], 7, 0)
board.place_piece(rook) 

knight = Knight.new("♞", "white", [], 1, 0)
board.place_piece(knight)
knight = Knight.new("♞", "white", [], 6, 0)
board.place_piece(knight)

bishop = Bishop.new("♝", "white", [], 2, 0)
board.place_piece(bishop)
bishop = Bishop.new("♝", "white", [], 5, 0)
board.place_piece(bishop)

queen = Queen.new("♛", "white", [], 3, 0)
board.place_piece(queen)

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

Piece.find_moves_by_color(board, 1)

def chess(board, turn)
  
  board.draw
  Piece.find_moves_by_color(board, turn)
  Piece.display_pieces_with_moves(board, turn)

  exit! if checkmate_slash_stalemate?(board, turn)
  exit! if threefold_repetition?(board)

  Piece.move(board, turn)
  chess(board, turn + 1)
end

chess(board, 1)
