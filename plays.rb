require_relative './board'

class Plays < Array
  attr_reader :initial_position, :directions
  
  def initialize arr
    @initial_position = arr.shift
    @directions = arr
  end

  def each_move(positions)
    hash = Board.prepare_pairs
    actual_position = @initial_position

    actual_xy = hash.key(@initial_position)
    actual_xy = actual_xy.scanf("%d%d")

    @directions.each do |direction|
      yield [actual_position, direction]
      actual_xy = actual_xy.zip(Board::MOVES[direction]).map {|v| v.compact.reduce(:+) } # magic to "sum" the two arrays
      actual_position = hash["#{actual_xy[0].to_s} #{actual_xy[1].to_s}"]
    end
  end
end