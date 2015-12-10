module BoardQuestions
  def legal_move?(cell, direction)
    return false unless Board.cell_exists?(cell)
    return false unless Board.valid_direction?(direction)

    xy = Board.cell_to_coordinates(cell)
    destiny = Board.calc_destination(xy, direction) # destination
    return false if destiny.nil? # dest out-of-bounds

    # this also checks for friendly pieces
    return false if there_a_piece?(destiny).is_a?(Integer) &&
                    !capture_valid?(destiny, direction)
    true
  end

  def capture_valid?(xy, direction)
    enemy = %w(o O) if @whose_turn == 0 # 0: White Code
    enemy = %w(x X) if @whose_turn == 1
    inc_xy = Board.calc_destination(xy, direction) # increased xy

    return false unless enemy.include?(@positions[xy[0], xy[1]])
    return false if there_a_piece?([inc_xy[0], inc_xy[1]]).is_a?(Integer)
    true
  end

  def there_a_piece?(xy) # Possible returns: BLACK, WHITE, -1
    return false unless %w(x X o O).include?(@positions[xy[0], xy[1]]) # There is no piece
    return 0 if %w(x X).include?(@positions[xy[0], xy[1]])
    return 1 if %w(o O).include?(@positions[xy[0], xy[1]])
    # Aka: return WHITE or BLACK
  end
end
