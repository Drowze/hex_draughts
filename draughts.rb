require_relative './board.rb'
require 'scanf'

class Draughts
  $white = 0 ## lower side
  $black = 1
  def initialize
    @positions = Matrix[
        ['E','E','E','E','E','E','E','E','E','E'],
         ['E','E','E','E','E','o','o','o','o','E'],
          ['E','E','E','E','o','o',' ','o','o','E'],
           ['E','E','E','o',' ','o','o',' ','o','E'],
            ['E','E',' ',' ',' ',' ',' ',' ',' ','E'],
             ['E',' ',' ',' ',' ',' ',' ',' ',' ','E'],
              ['E',' ',' ',' ',' ',' ',' ',' ','E','E'],
               ['E','x',' ','x','x',' ','x','E','E','E'],
                ['E','x','x',' ','x','x','E','E','E','E'],
                 ['E','x','x','x','x','E','E','E','E','E'],
                  ['E','E','E','E','E','E','E','E','E','E']
    ]
    @board_pairs = Board.prepare_pairs
    @black_pieces_left = 12
    @white_pieces_left = 12
    @whose_turn = $white
  end

  def start_game
    print_board
    ask_player @whose_turn
  end

  def ask_player color
    print ' ' * 20
    puts "It's white's turn" if color == $white
    puts "It's black's turn" if color == $black
    loop do
      puts "\nPlease input your move below (eg \'d2 ne\' or \'c5 h4 nw\')"
      str = gets.chomp.split
      if legal_move?(str) then
        break
      else
        puts 'invalid move'
      end
    end
  end

  def legal_move? str
    piece = str.shift; directions = str
    return false if not @board_pairs.key(piece) # check if the cell exist
    
    piece = @board_pairs.key(piece).scanf("%d %d") # cell into "row column" (for the matrix)
    x = piece[0]; y = piece[1] # just to simplify future uses of those variables

    arr = ['x','X'] if @whose_turn == $white
    arr = ['o','O'] if @whose_turn == $black

    return false if not arr.include?(@positions[x, y]) # check if there's valid piece on the cell 
    return false if not ((str - ['nw', 'ne', 'sw', 'se']).empty?) # check if direction is valid

    str.each do |direction|
      return false if not destination_in_bounds?(x,y,direction)
      return false if destination_same_color?(x,y,direction)
    end
    return true
  end

  def destination_in_bounds? x, y, dest
    case dest
    when 'nw' then
      return true unless @positions[x-1,y] == 'E'
    when 'ne' then
      return true unless @positions[x-1,y+1] == 'E'
    when 'sw' then
      return true unless @positions[x+1,y-1] == 'E'
    when 'se' then
      return true unless @positions[x+1,y] == 'E'
    else
      return false
    end
  end

  def destination_same_color? x, y, dest
    arr = ['x','X'] if @whose_turn == $white
    arr = ['o','O'] if @whose_turn == $black
    case dest
    when 'nw' then
      return true if arr.include?@positions[x-1,y]
    when 'ne' then
      return true if arr.include?@positions[x-1,y+1]
    when 'sw' then
      return true if arr.include?@positions[x+1,y-1]
    when 'se' then
      return true if arr.include?@positions[x+1,y]
    else
      return false
    end
  end

  def print_board
  	print Board.prepare_board(@positions)
  end

  def game_finished?
    @black_pieces_left == 0 || @white_pieces_left == 0
  end
end

=begin
  Moves: nw, ne, sw, se
=end