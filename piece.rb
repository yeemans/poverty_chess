require_relative 'rook.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'

class Piece 
  attr_accessor :char, :color, :moves, :column, :row
  def initialize(char, color, moves, column, row)
    @char = char
    @color = color 
    @moves = moves
    @column = column 
    @row = row
  end
end





