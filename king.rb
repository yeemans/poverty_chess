require_relative 'pawn.rb'

class King
  attr_accessor :char, :color, :moves, :column, :row, :has_moved
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
    @has_moved = false
  end

  def get_enemy_pawns(board)
    pawns = []
    board.cells.each do |cell| 
      pawns.push(cell) if cell != "#" && cell.class.name == "Pawn" && !Piece.same_color?(self, cell)
    end
    return pawns
  end

  def get_enemy_pieces(board)
    pieces = []
    board.cells.each do |cell| 
      pieces.push(cell) if cell != "#" && self.color != cell.color
    end
    return pieces
  end

  def get_enemy_moves(board)
    moves = []
    pieces = self.get_enemy_pieces(board)
    pieces.each do |piece| moves.push(piece.moves) end

    return moves
  end

  def get_moves(board)
    squares = [-9, -8, -7, -1, 1, 7, 8, 9]
    # make sure the king can't teleport to the other side of the board 
    squares.delete(7) if self.column == 0
    squares.delete(-1) if self.column == 0 
    squares.delete(1) if self.column == 7 
    squares.delete(-7) if self.column == 7
    
    squares.each do |square| 
      move = self.row * 8 + self.column + square
      if Piece.hit_piece(board, move) 
        self.moves.push(move) if move.between?(0, 63) && !Piece.same_color?(self, board.cells[move])  
        next
      end
      self.moves.push(move) if move.between?(0, 63)
    end

    return self.moves
  end

  def in_check?(board) 
    self.get_enemy_pieces(board).each do |piece| 
      king_square = Piece.get_king(self.color, board)
      return true if piece.moves.include?(king_square)
    end
    return false
  end

  def castle_white(board)
    return if self.has_moved || self.in_check?(board)
    white_kingside_castle(board)
    white_queenside_castle(board) 
  end

  def castle_black(board)
    return if self.has_moved || self.in_check?(board)
    black_kingside_castle(board)
    black_queenside_castle(board)
  end

  def white_kingside_castle(board)
    squares = []
    (4..7).each do |cell| squares.push(board.cells[cell]) end
    if board.cells[7] != "#"
      return if board.cells[7].class.name == "Rook" && board.cells[7].has_moved
    end
    # can't castle through check or into check 
    return if get_enemy_moves(board).flatten.include?(5) || get_enemy_moves(board).flatten.include?(6)
    return if squares[0] == "#" || squares[0].class.name != "King" || squares[0].color != "white"
    return if squares[1] != "#" || squares[2] != "#"
    return if squares[3] == "#" || squares[3].class.name != "Rook" || squares[3].color != "white"
    self.moves.push(6)
  end
  
  def white_queenside_castle(board)
    squares = []
    (0..4).each do |cell| squares.push(board.cells[cell]) end
    if board.cells[0] != "#"
      return if board.cells[0].class.name == "Rook" && board.cells[0].has_moved
    end
    # can't castle through check or into check
    return if get_enemy_moves(board).flatten.include?(2) || get_enemy_moves(board).flatten.include?(3)
    return if squares[0] == "#" || squares[0].class.name != "Rook" || squares[0].color != "white"
    return if squares[1] != "#" || squares[2] != "#" || squares[3] != "#"
    return if squares[4] == "#" || squares[4].class.name != "King" || squares[4].color != "white"
    self.moves.push(2)
  end

  def black_kingside_castle(board)
    squares = []
    (60..63).each do |cell| squares.push(board.cells[cell]) end
    if board.cells[63] != "#"
      return if board.cells[63].class.name == "Rook" && board.cells[63].has_moved
    end
    # can't castle through check or into check 
    return if get_enemy_moves(board).flatten.include?(61) || get_enemy_moves(board).flatten.include?(62)
    return if squares[0] == "#" || squares[0].class.name != "King" || squares[0].color != "black"
    return if squares[1] != "#" || squares[2] != "#"
    return if squares[3] == "#" || squares[3].class.name != "Rook" || squares[3].color != "black"
    self.moves.push(62)
  end 

  def black_queenside_castle(board)
    squares = []
    (56..60).each do |cell| squares.push(board.cells[cell]) end
    if board.cells[0] != "#"
      return if board.cells[56].class.name == "Rook" && board.cells[56].has_moved
    end
    # can't castle through check or into check
    return if get_enemy_moves(board).flatten.include?(58) || get_enemy_moves(board).flatten.include?(59)
    return if squares[0] == "#" || squares[0].class.name != "Rook" || squares[0].color != "black"
    return if squares[1] != "#" || squares[2] != "#" || squares[3] != "#"
    return if squares[4] == "#" || squares[4].class.name != "King" || squares[4].color != "black"
    self.moves.push(58)
  end

  def white_kingside_castle_move(board)
    # copy the rook onto square 5
    board.cells[5] = board.cells[7]
    board.cells[5].column = 5 
    board.cells[7] = "#"
  end

  def white_queenside_castle_move(board)
    board.cells[3] = board.cells[0]
    board.cells[3].column = 3 
    board.cells[0] = "#"
  end

  def black_kingside_castle_move(board)
    board.cells[61] = board.cells[63]
    board.cells[61].column = 5 
    board.cells[63] = "#"
  end

  def black_queenside_castle_move(board)
    board.cells[59] = board.cells[56]
    board.cells[59].column = 3 
    board.cells[56] = "#"
  end

end