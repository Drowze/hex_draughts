module BoardQuestions
  def legal_move?(positions, cell, direction, whose_turn)
    return false unless Board.cell_exists?(cell)
    xy = Board.cell_to_coordinates(cell)
    return false unless Board.there_a_piece?(positions, xy) == whose_turn
    return false unless Board.valid_direction?(direction)
    return false unless backwards_valid?(positions, xy, direction)
    destiny = Board.calc_destination(xy, direction) # destination

    return false unless Board.coordinates_exists?(destiny)

    # this also checks for friendly pieces
    return false if there_a_piece?(positions, destiny).is_a?(Integer) &&
                    !capture_valid?(positions, destiny, direction, whose_turn)
    true
  end

  def capture_valid?(positions, xy, direction, whose_turn)
    enemy = %w(o O) if whose_turn == 0 # 0: White Code
    enemy = %w(x X) if whose_turn == 1
    inc_xy = Board.calc_destination(xy, direction) # increased xy

    return false unless enemy.include?(coordinates_to_piece(positions, xy))
    return false if there_a_piece?(positions, [inc_xy[0], inc_xy[1]]).is_a?(Integer)
    true
  end

  def there_a_piece?(positions, xy) # Possible returns: BLACK, WHITE, -1
    ret = coordinates_to_piece(positions, xy)
    return 0 if %w(x X).include?(ret)
    return 1 if %w(o O).include?(ret)
    return false
  end

  def backwards_valid?(positions, xy, dir)
    piece = coordinates_to_piece(positions, xy)
    return false if piece == 'x' && (dir == 'se' || dir == 'sw')
    return false if piece == 'o' && (dir == 'ne' || dir == 'nw')
    true
  end

  def cell_to_piece(positions, cell)
    fail unless Board.cell_exists?(cell)
    xy = Board.cell_to_coordinates(cell)
    positions[xy[0], xy[1]]
  end

  def coordinates_to_piece(positions, xy)
    fail unless Board.coordinates_exists?(xy)
    positions[xy[0], xy[1]]
  end

  def got_the_flag?(positions, cell)
    north = %w(1e 1g 1i 1k)
    south = %w(9e 9g 9i 9k)
    piece = cell_to_piece(positions, cell)
    
    piece = Board.cell_to_piece(positions, cell)
    if piece == 'x' && north.include?(cell)
      true
    elsif piece == 'o' && south.include?(cell)
      true
    else
      false
    end
  end
end
