require 'scanf'
require 'matrix'
require_relative './class_extenders'

require_relative './board'
require_relative './draughts'
require_relative './plays'

obj = Draughts.new
obj.start_game

# hash = Board.prepare_pairs
# puts(hash.map{ |k, v| "#{k} => #{v}" }.sort )
