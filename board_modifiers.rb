module BoardModifiers
  # make_move method expects that everything was checked beforehand
  def make_move(positions, cell, direction) # Returns the modified board
    origin = Board.cell_to_coordinates(cell)
    destiny = Board.calc_destination(Board.cell_to_coordinates(cell), direction)

    if there_a_piece?(positions, destiny) == false
      positions = simple_move(positions, origin, direction)
      it_was = 'move'
    else
      positions = make_capture(positions, origin, direction)
      destiny = Board.calc_destination(destiny, direction) # increasing destiny
      it_was = 'capture'
    end

    positions = evolve_to_king(positions, destiny) if got_the_flag?(positions, Board.coordinates_to_cell(destiny))

    msg = "Command: #{direction} | From #{cell} to #{Board.coordinates_to_cell(destiny)}\n"
    [it_was, positions, destiny, msg]
  end

  def simple_move(positions, origin, direction)
    destiny = Board.calc_destination(origin, direction)
    positions[destiny[0], destiny[1]] = positions[origin[0], origin[1]]
    positions[origin[0], origin[1]] = ' '
    positions
  end

  def make_capture(positions, origin, direction)
    destiny = Board.calc_destination(origin, direction) # destiny is enemy's cell
    positions[destiny[0], destiny[1]] = ' ' # piece in enemy's cell removed
    destiny = Board.calc_destination(destiny, direction) # destiny updated to next cell
    positions[destiny[0], destiny[1]] = positions[origin[0], origin[1]] # destiny now has origin's piece
    positions[origin[0], origin[1]] = ' ' # origin's cell is now empty
    positions
  end

  def remove_enemy_piece(whose_turn, pieces_left)
    if whose_turn == 0 # 0: White code
      pieces_left['black'] -= 1
      return [pieces_left, "Black piece removed. #{pieces_left['black']} left."]
    elsif whose_turn == 1 # 1: Black code
      pieces_left['white'] -= 1
      return [pieces_left, "White piece removed. #{pieces_left['white']} left."]
    else
      fail InvalidTurn
    end
  end

  def evolve_to_king(positions, xy) # return a positions matrix modified
    positions[xy[0], xy[1]].upcase!
    positions
  end
end

# def respective_arrow(player, dir)
#   "\u2196"
#   "\u2197"
#   "\u2199"
#   "\u2198"
# end
