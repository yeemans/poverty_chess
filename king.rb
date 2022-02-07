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
      pieces.push(cell) if cell != "#" && self.color != cell.color && cell.class.name != "Pawn"
    end
    return pieces
  end

  def get_enemy_moves(board)
    moves = []
    pieces = self.get_enemy_pieces(board)
    pieces.each do |piece| moves.push(piece.moves) end

    return moves.push(check_for_pawns(board))
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
    self.check_for_pawns(board) # cannot go to a pawn's diagonal
    return self.moves
  end

  def white_pawn_diagonals(pawn)
    diag_left = pawn.row * 8 + pawn.column - 7
    diag_right = pawn.row * 8 + pawn.column - 9

    diagonals = [diag_left, diag_right]
    diagonals.delete(diag_left) if pawn.column == 0
    diagonals.delete(diag_right) if pawn.column == 7

    return diagonals
  end

  def black_pawn_diagonals(pawn)
    diag_left = pawn.row * 8 + pawn.column + 7
    diag_right = pawn.row * 8 + pawn.column + 9

    diagonals = [diag_left, diag_right]
    diagonals.delete(diag_left) if pawn.column == 0
    diagonals.delete(diag_right) if pawn.column == 7
    
    return diagonals.flatten
  end

  def check_for_pawns(board)
    pawn_moves = []

    self.get_enemy_pawns(board).each do |pawn| 
      pawn_moves.push(black_pawn_diagonals(pawn)) if self.color == "white"
      pawn_moves.push(white_pawn_diagonals(pawn)) if self.color == "black"
    end

    pawn_moves = pawn_moves.flatten
    self.moves = self.moves.select {|move| !pawn_moves.include?(move)}
    return pawn_moves
  end

  def in_check?(board) 
    self.get_enemy_pieces(board).each do |piece| 
      king_square = Piece.get_king(self, board)
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
    return if get_enemy_moves(board).flatten.include?(2) || get_enemy_moves(board).flatten.include?(3)
    return if squares[0] == "#" || squares[0].class.name != "Rook" || squares[0].color != "white"
    return if squares[1] != "#" || squares[2] != "#" || squares[3] != "#"
    return if squares[4] == "#" || squares[4].class.name != "King" || squares[4].color != "white"
    self.moves.push(2)
  end
end