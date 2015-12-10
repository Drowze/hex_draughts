module BoardQuestions
  def legal_move?(positions, cell, direction, whose_turn)
    return false unless Board.cell_exists?(cell)
    xy = Board.cell_to_coordinates(cell)
    return false unless Board.there_a_piece?(positions, xy)
    return false unless Board.valid_direction?(direction)
    return false unless backwards_valid?(positions, xy, direction)
    destiny = Board.calc_destination(xy, direction) # destination
    return false if destiny.nil? # dest out-of-bounds

    # this also checks for friendly pieces
    return false if there_a_piece?(positions, destiny).is_a?(Integer) &&
                    !capture_valid?(positions, destiny, direction, whose_turn)
    true
  end

  def capture_valid?(positions, xy, direction, whose_turn)
    enemy = %w(o O) if whose_turn == 0 # 0: White Code
    enemy = %w(x X) if whose_turn == 1
    inc_xy = Board.calc_destination(xy, direction) # increased xy

    return false unless enemy.include?(positions[xy[0], xy[1]])
    return false if there_a_piece?(positions, [inc_xy[0], inc_xy[1]]).is_a?(Integer)
    true
  end

  def there_a_piece?(positions, xy) # Possible returns: BLACK, WHITE, -1
    return false unless %w(x X o O).include?(positions[xy[0], xy[1]]) # There is no piece
    return 0 if %w(x X).include?(positions[xy[0], xy[1]])
    return 1 if %w(o O).include?(positions[xy[0], xy[1]])
    # Aka: return WHITE or BLACK
  end

  def backwards_valid?(positions, xy, dir)
    piece = positions[xy[0], xy[1]]
    return false if piece == 'x' && (dir == 'se' || dir == 'sw')
    return false if piece == 'o' && (dir == 'ne' || dir == 'nw')
    true
  end
end
