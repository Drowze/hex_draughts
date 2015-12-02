require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class String
  def step(c, delta=1)
    if c.ord + delta > 122 then
      return [c.ord + delta - 26].pack 'U'
    elsif c.ord + delta < 97 then
      return [c.ord + delta + 26].pack 'U'
    else
      return [c.ord + delta].pack 'U'
    end
  end

  def increment(c)
    c %= 26
    step self, c
  end

  def decrement(c)
    c %= 26
    step self, -c
  end
end

class Board
  attr_reader :cell_pairs
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

  def self.prepare_board positions
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

  def self.prepare_pairs
    @cell_pairs = Hash.new
    start_letter = 'a'
    increment = 0
    checker = 0
    $cell_codes.each_with_index do |element, row, col|
      if row <= 5
        if checker != row then # I get here everytime it goes to another row
          increment = -row + 5
          checker = row
        end
        if(element == 7) then
          @cell_pairs["#{row}, #{col}"] = "#{row.to_s}#{start_letter.increment(increment)}"
          increment += 2
        end
      else
        if checker != row then # I get here everytime it goes to another row
          increment = row - 5
          checker = row
        end
        if(element == 7) then
          @cell_pairs["#{row}, #{col}"] = "#{row.to_s}#{start_letter.increment(increment)}"
          increment += 2
        end
      end
    end
    return @cell_pairs
  end
end