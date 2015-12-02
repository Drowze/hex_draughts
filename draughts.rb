require_relative './board'
require_relative './class_extenders'
require_relative './plays'
require 'scanf'
require 'matrix'


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
      invalid_move = false
      puts "\nPlease input your move below (eg \'d2 ne\' or \'c5 h4 nw\')"
      all_moves = Plays.new(gets.chomp.split)
      all_moves.each_move(@positions) do |move| 
        piece = move[0]
        direction = move[1]
        invalid_move = true if not legal_move?(piece,direction)
      end
      break unless invalid_move == true
      puts 'Invalid move made'
    end
  end

  def legal_move? piece, direction
    return false if not @board_pairs.key(piece) # check if the cell exist
    
    piece = @board_pairs.key(piece).scanf("%d %d") # cell into "row column" (for the matrix)
    x = piece[0]; y = piece[1] # just to simplify future uses of those variables

    arr = ['x','X'] if @whose_turn == $white
    arr = ['o','O'] if @whose_turn == $black
    return false if not arr.include?(@positions[x, y]) # check if there's valid piece on the cell 
    return false if not destination_in_bounds?(x,y,direction) # check if direction is valid
    return false if destination_same_color?(x,y,direction)

    return true
  end

  def is_there_a_piece? x, y
    ['x','X','o','O'].include?(@positions[x,y])
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

  def capture_valid? x, y, dest
    enemy = ['o','O'] if @whose_turn == $white
    enemy = ['x','X'] if @whose_turn == $black

    case dest
      when 'nw' then
        return false if not enemy.include?(@positions[x-1,y])
        return false if not destination_in_bounds?(@positions[x-2,y])
        return false if is_there_a_piece?(@positions[x-2,y])
      when 'ne' then
        return false if not enemy.include?(@positions[x-1,y+1])
        return false if not destination_in_bounds?(@positions[x-2,y+2])
        return false if is_there_a_piece?(@positions[x-2,y+2])
      when 'sw' then
        return false if not enemy.include?(@positions[x+1,y-1])
        return false if not destination_in_bounds?(@positions[x+2,y-2])
        return false if is_there_a_piece?(@positions[x+2,y-2])
      when 'se' then
        return false if not enemy.include?(@positions[x+1,y])
        return false if not destination_in_bounds?(@positions[x+2,y])
        return false if is_there_a_piece?(@positions[x+2,y])
      else
        return true
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