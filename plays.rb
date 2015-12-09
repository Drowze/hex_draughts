require_relative './board'

class Plays < Array
  attr_reader :initial_position, :directions

  def initialize(arr)
    @initial_position = arr.shift
    @directions = arr
  end

  def each_move
    hash = Board.prepare_pairs
    actual_position = @initial_position

    actual_xy = hash.key(@initial_position).scanf('%d%d')

    @directions.each do |direction|
      yield [actual_position, direction]
      fail 'invalid direction' unless Board::MOVES[direction] # verify if directiin is valid
      actual_xy = actual_xy.zip(Board::MOVES[direction]).map { |v| v.compact.reduce(:+) } # magic to "sum" the two arrays
      actual_position = hash["#{actual_xy[0]} #{actual_xy[1]}"]
    end
  end

  # def each_capture(positions)
  #   hash = Board.prepare_pairs
  #   actual_position = @initial_position # position is the NUMBER-LETTER form

  #   actual_xy = hash.key(@initial_position)
  #   actual_xy = actual_xy.scanf("%d%d")

  #   for i in 0..captures-1
  #     yield [actual_position, @directions[i]]
  #     raise 'invalid direction' unless Board::MOVES[direction] # verify if directiin is valid
  #     actual_xy = Board.calc_destination(actual_xy, Board::MOVES[@directions[i]])
  #     actual_position = hash["#{actual_xy[0].to_s} #{actual_xy[1].to_s}"]
  #   end
  # end

  def contains_huffing?
    @directions[0].to_i != 0
  end
end
