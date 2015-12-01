require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Board
  attr_reader :board
  $cell_codes = Matrix[
    [0,0,0,0,0,1,3,3,3,2],
     [0,0,0,0,5,7,7,7,7,2],
      [0,0,0,5,7,7,7,7,7,2],
       [0,0,5,7,7,7,7,7,7,2],
        [0,5,7,7,7,7,7,7,7,2],
         [4,7,7,7,7,7,7,7,7,0],
          [4,7,7,7,7,7,7,7,0,0],
           [4,7,7,7,7,7,7,0,0,0],
            [4,7,7,7,7,7,0,0,0,0],
             [4,7,7,7,7,0,0,0,0,0]
  ]

  def initialize positions
    @board = prepare_board(positions)
  end

  def prepare_board positions
    seq = [' ',1,2,3,4,5,6,7,8,9,' ']
    counter = 0
    indentation = 0
    ret = ''

    $cell_codes.to_a.map.with_index do |m, i| 
      ret += seq[counter].to_s + ' ' * indentation
      m.each_with_index do |n, j| 
        n == 7 ? ret += ("#{positions[i,j]} ") : ret += ('  ') # piece occupying the cell
        [4,5,6,7].include?(n) ? ret += ('| ') : ret += ('  ')
      end
      ret += "\n" + ' ' * indentation
      m.each do |n|
        [2,3,6,7].include?(n) ? ret += ('\\ ') : ret += ('  ')
        [1,3,5,7].include?(n) ? ret += ('/ ') : ret += ('  ')
      end
      ret += "\n"
      counter+=1
      indentation+=2
    end
    ret += "\n" + ' ' * 15 + 'a b c d e f g h i j k l m n o' + "\n"
    ret
  end
end