require_relative 'rook.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'king.rb'

module Piece

  def Piece.square_to_notation(square)
    board = ['a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1', 'h1',
             'a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2', 
             'a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3', 'h3', 
             'a4', 'b4', 'c4', 'd4', 'e4', 'f4', 'g4', 'h4', 
             'a5', 'b5', 'c5', 'd5', 'e5', 'f5', 'g5', 'h5', 
             'a6', 'b6', 'c6', 'd6', 'e6', 'f6', 'g6', 'h6', 
             'a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7', 
             'a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8']
    return board[square]
  end

  def Piece.hit_piece(board, index)
    return board.get_square(index) != "#"
  end

  def Piece.same_color?(piece1, piece2)
    return piece1.color == piece2.color
  end

  def Piece.is_king?(piece)
    return piece.class.name == "King"
  end

  def Piece.is_pawn?(piece)
    return piece.class.name == "Pawn"
  end

  def Piece.attackers(piece, square, board)
    attackers = []
    board.cells.each do |cell| 
      next if cell == "#" || cell.color == piece.color 
      attackers.push(cell) if cell.moves.include?(square)
    end
    return attackers
  end

  def Piece.get_king(color, board)
    # returns king of same color
    board.cells.each.with_index do |cell, index|
      return index if cell != "#" && Piece.is_king?(cell) && cell.color == color
    end
  end

  def Piece.opposing_king(piece, board)
    # returns king of opposite color
    board.cells.each.with_index do |cell, index|
      return index if cell != "#" && Piece.is_king?(cell) && !Piece.same_color?(piece, cell) 
    end
  end

  def Piece.all_pieces(board)
    pieces = []
    board.cells.each do |cell|
      pieces.push(cell) if cell != "#"
    end
    return pieces
  end

  def get_enemy_pieces(board)
    pieces = []
    board.cells.each do |cell| 
      pieces.push(cell) if cell != "#" && self.color != cell.color 
    end
    return pieces
  end

  def Piece.test_move(piece, move, board) 
    board_copy = Board.new([], [])
    board_copy.cells = board.copy_cells

    # move piece from its square, unless it swallows the king
    if Piece.is_king?(board_copy.cells[move]) 
      return if piece.color == board_copy.cells[move].color 
    end
    board_copy.cells[move] = piece 
    board_copy.cells[piece.row * 8 + piece.column] = "#"
    king = board_copy.cells[Piece.get_king(piece.color, board_copy)]

    king.get_enemy_pieces(board_copy).each do |e| 
      e.moves = []
      e.get_moves(board_copy)
    end
    return board_copy
  end

  def Piece.king_checkers(board)
    checkers = []
    Piece.all_pieces(board).each do |piece| 
      king = Piece.opposing_king(piece, board)
      checkers.push(piece) if piece.moves.include?(king)
    end
    return checkers
  end
  
  # function that filters out moves that result in check
  def Piece.discard_checks(board, color, turn)
    color == 'white' ? (pieces = Piece.white_pieces(board)) : (pieces = Piece.black_pieces(board))
    turn % 2 == 0 ? (color_moving = 'black') : (color_moving = 'white')
    # only discard checks for the color that is moving
    return unless color_moving == color

    pieces.each do |piece|
      piece.moves.each do |move|  
        board_copy = Piece.test_move(piece, move, board)
        next unless board_copy # invalid board

        king = Piece.get_king(piece.color, board_copy)
        king = board_copy.cells[king]

        # recalculate the moves of all pieces that check the king
        piece.moves[piece.moves.index(move)] = nil if king.in_check?(board_copy)
        piece.moves = piece.moves.select { |m| m != nil}
      end
    end
  end

  def Piece.checking_king?(piece, board)
    king = Piece.opposing_king(piece, board)
    return true if piece.moves.include?(king)
    return false
  end
  
  def Piece.add_castling(board, color)
    king = board.cells[Piece.get_king(color, board)]
    king.castle_white(board) if color == "white"
    king.castle_black(board) if color == "black"
  end

  def Piece.generate_moves(board, color, turn)
    (0..63).each do |cell| 
      if Piece.hit_piece(board, cell) && board.cells[cell].color == color
        board.cells[cell].moves = []
        board.cells[cell].get_moves(board)
        Piece.add_check_moves(board.cells[cell], board)
      end
    end

    Piece.discard_checks(board, color, turn)
    Piece.add_castling(board, color)
  end
  
  def Piece.find_moves_by_color(board, turn)
    turn % 2 == 0 ? (color = 'black') : (color = 'white')
    # generate moves for pieces of color variable first, then pieces of the other color 
    if color == "white"
      Piece.generate_moves(board, 'black', turn)
      Piece.generate_moves(board, 'white', turn)
    elsif color == "black"   
      Piece.generate_moves(board, 'white', turn)
      Piece.generate_moves(board, 'black', turn)
    end
  end

  def Piece.add_check_moves(piece, board)
    if Piece.checking_king?(piece, board)
      # add moves to the piece if it checks the opposing king 
      king = Piece.opposing_king(piece, board)
      # remove king from this board copy
      board_copy = Board.new([], [])
      board_copy.cells = board.copy_cells
      board_copy.cells[king] = "#"
      piece.get_moves(board_copy)
    end
  end

  def Piece.white_pieces(board)
    pieces = []
    board.cells.each do |cell| 
      next if cell == "#" || cell.color != "white"
      pieces.push(cell) unless cell.moves.empty?
    end
    return pieces
  end

  def Piece.black_pieces(board)
    pieces = []
    board.cells.each do |cell| 
      next if cell == "#" || cell.color != "black"
      pieces.push(cell) unless cell.moves.empty?
    end
    return pieces
  end

  def Piece.remove_collisions(board, color)
    # cannot take your own pieces 
    board.cells.each do |cell| 
      next if cell == "#" || cell.color != color 
      cell.moves = cell.moves.select {|m| board.cells[m] == "#" || board.cells[m].color != color}
    end
  end

  def Piece.display_pieces_with_moves(board, turn)
    turn % 2 == 0 ? (color = "black") : (color = "white")
    Piece.remove_collisions(board, color) # can't hit your own pieces 
    color == "black" ? (pieces = Piece.black_pieces(board)) : (pieces = Piece.white_pieces(board))
    
    pieces.each_with_index do |piece, index| 
      square = Piece.square_to_notation(piece.row * 8 + piece.column) # show chess notation
      p "#{index}: #{piece.char}, #{square}"
    end
  end

  def Piece.input_move(board, turn)
    # get pieces of appropriate color 
    turn % 2 == 0 ? (pieces = Piece.black_pieces(board)) : (pieces = Piece.white_pieces(board))

    p "Piece: (0 - #{pieces.count - 1})"
    index = gets.chomp
    return Piece.input_move(board, turn) if index.to_i == 0 && index != "0"
    return Piece.input_move(board, turn) unless Piece.valid?(index.to_i, pieces)

    return pieces[index.to_i]
  end

  def Piece.display_moves(piece, board)
    files = ["a", "b", "c", "d", "e", "f", "g", "h"] 
    piece.moves.each_with_index do |move, index| 
      notation = Piece.square_to_notation(move)
      p "#{index}: #{notation}"
    end
  end

  def Piece.move(board, turn)
    piece = Piece.input_move(board, turn)
    moves = piece.moves

    Piece.display_moves(piece, board)
    p "Move: (0 - #{moves.count - 1})"
    choice = gets.chomp.to_i 

    Piece.castle(piece, moves[choice], board) if piece.class.name == "King" # add castle move
    Piece.capture_enpassant(piece, moves[choice], board) if piece.class.name == "Pawn" # add enpassant
    
    board.cells[moves[choice]] = piece # move piece
    board.cells[piece.row * 8 + piece.column] = "#" # piece's old square is now a #

    piece.has_moved = true if piece.class.name == "King" || piece.class.name == "Rook" # for castle
    # store piece's old column and row for the move list 
    old_column = piece.column
    old_row = piece.row
    Piece.update(piece, moves[choice])

    # add to move list, like a pgn 
    board.move_list.push({:piece => piece.class.name, :color => piece.color, :move => moves[choice], 
    :from_square => old_row * 8 + old_column})
    # promotion for pawns 
    piece.promotion(board) if Piece.is_pawn?(piece)
  end

  def Piece.castle(king, move, board)
    square = king.row * 8 + king.column 

    king.white_kingside_castle_move(board) if square == 4 && move == 6 
    king.white_queenside_castle_move(board) if square == 4 && move == 2
    king.black_kingside_castle_move(board) if square == 60 && move == 62
    king.black_queenside_castle_move(board) if square == 60 && move == 58
  end

  def Piece.capture_enpassant(pawn, move, board)
    square = pawn.row * 8 + pawn.column
    if pawn.color == 'black'
      pawn.black_enpassant_capture(move, board) if move == square - 7 || move == square - 9 
    elsif pawn.color == 'white'  
      pawn.white_enpassant_capture(move, board) if move == square + 7 || move == square + 9 
    end
  end

  def Piece.valid?(index, list)
    return false if index > list.count - 1 
    return false if index < 0  
    return true
  end

  def Piece.update(piece, square)
    # change a number square, like 46, to row and column
    row = 0 
    while square > 7 
      row += 1 
      square -= 8
    end
    piece.column = square 
    piece.row = row
  end

end




