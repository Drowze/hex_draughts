require_relative './board'
require_relative './draughts'

obj = Draughts.new
obj.start_game

# hash = Board.prepare_pairs
# puts( hash.map{ |k,v| "#{k} => #{v}" }.sort )