require_relative './board'
require_relative './draughts.rb'

obj = Draughts.new
obj.print_board

hash = Board.prepare_pairs
puts( hash.map{ |k,v| "#{k} => #{v}" }.sort )