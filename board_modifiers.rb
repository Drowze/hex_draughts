module BoardModifiers
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
    puts remove_enemy_piece
  end

  def remove_enemy_piece
    if @whose_turn == 0 # 0: White code
      @black_pieces_left -= 1
      'Black piece removed'
    elsif @whose_turn == 1 # 1: Black code
      @white_pieces_left -= 1
      'White piece removed'
    else
      fail InvalidTurn
    end
  end
end
