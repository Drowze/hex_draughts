require 'matrix'
load './board.rb', true

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class String # Only works for single letters; could be extended to uppercase letters too
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
    return nil if self.size > 1
    c %= 26
    step self, c
  end

  def decrement(c)
    return nil if self.size > 1
    c %= 26
    step self, -c
  end
end