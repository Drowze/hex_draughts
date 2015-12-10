require_relative './class_extenders'
require 'matrix'
require 'scanf'
require 'colorize'

class Board
  attr_reader :cell_pairs
  MOVES = {
    'nw' => [-1, 0],
    'ne' => [-1, +1],
    'sw' => [+1, -1],
    'se' => [+1, 0]
  }
  CELL_CODES = Matrix[
    [0, 0, 0, 0, 0, 1, 3, 3, 3, 2],
    [0, 0, 0, 0, 5, 7, 7, 7, 7, 2],
    [0, 0, 0, 5, 7, 7, 7, 7, 7, 2],
    [0, 0, 5, 7, 7, 7, 7, 7, 7, 2],
    [0, 5, 7, 7, 7, 7, 7, 7, 7, 2],
    [4, 7, 7, 7, 7, 7, 7, 7, 7, 0],
    [4, 7, 7, 7, 7, 7, 7, 7, 0, 0],
    [4, 7, 7, 7, 7, 7, 7, 0, 0, 0],
    [4, 7, 7, 7, 7, 7, 0, 0, 0, 0],
    [4, 7, 7, 7, 7, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ]

  def self.prepare_board(positions)
    seq = [' ', 1, 2, 3, 4, 5, 6, 7, 8, 9, ' ']
    counter = 0
    indentation = 0
    ret = ''

    CELL_CODES.to_a.map.with_index do |m, i|
      if i != 10
        ret += seq[counter].to_s + ' ' * indentation
        m.each_with_index do |n, j|
          n == 7 ? ret += ("#{positions[i, j]} ") : ret += ('  ') # actiual piece
          [4, 5, 6, 7].include?(n) ? ret += ('| ') : ret += ('  ')
        end
        ret += "\n" + ' ' * indentation unless i == CELL_CODES.to_a.map.size - 1
        m.each_with_index do |n|
          [2, 3, 6, 7].include?(n) ? ret += ('\\ ') : ret += ('  ')
          [1, 3, 5, 7].include?(n) ? ret += ('/ ') : ret += ('  ')
        end
        ret += "\n"
        counter += 1
        indentation += 2
      end
    end
    ret += ' ' * 15 + 'a b c d e f g h i j k l m n o' + "\n"
    ret
  end

  def self.prepare_pairs
    @cell_pairs = {}
    start_letter = 'a'
    increment = 0
    checker = 0
    CELL_CODES.each_with_index do |element, row, col|
      if row <= 5
        if checker != row # I get here everytime it goes to another row
          increment = -row + 5
          checker = row
        end
        if element == 7
          @cell_pairs[[row, col]] = "#{row}#{start_letter.increment(increment)}"
          increment += 2
        end
      else
        if checker != row # I get here everytime it goes to another row
          increment = row - 5
          checker = row
        end
        if element == 7
          @cell_pairs[[row, col]] = "#{row}#{start_letter.increment(increment)}"
          increment += 2
        end
      end
    end
    @cell_pairs
  end

  def self.calc_destination(arr, dir)
    fail ArgumentError, 'Invalid direction', caller unless valid_direction?(dir)

    ret = [arr[0] + MOVES[dir][0], arr[1] + MOVES[dir][1]]
    return nil unless prepare_pairs[ret] # check if out-of-bounds
    ret
  end

  def self.sub_destination(arr, dir)
    fail ArgumentError, 'Invalid direction', caller unless valid_direction?(dir)

    ret = [arr[0] - MOVES[dir][0], arr[1] - MOVES[dir][1]]
    return nil unless prepare_pairs[ret] # check if out-of-bounds
    ret
  end

  def self.valid_direction?(dir)
    !MOVES[dir].nil?
  end

  def self.cell_exists?(cell)
    !prepare_pairs.key(cell).nil?
  end

  def self.coordinates_exists?(xy)
    !prepare_pairs[xy].nil?
  end

  def self.cell_to_coordinates(cell)
    prepare_pairs.key(cell)
  end

  def self.coordinates_to_cell(arr)
    prepare_pairs[arr]
  end
end

# Print the keys for reference:
# puts(Board.prepare_pairs.map { |k, v| "#{k} => #{v}" }.sort)
