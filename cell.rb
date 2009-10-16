
# Individual 'square' that you write a number in.
#
class Cell

  attr_accessor :val
  attr_reader :x, :y, :col, :row, :grid
  # list of current possibilities for this cell
  attr_reader :pencils
  attr_reader :pens # opposite of pencils (known impossibilities)

  # If a +val+ is passed on initialization, consider it immutable.
  #
  def initialize(x, y, col, row, grid, val=nil)
    @x = x; @y = y
    @col = col; @row = row; @grid = grid

    @col << self
    @row << self
    @grid << self
    unless val.nil?
      @val = val
      @val_immutable = true
    end
  end

  # All initial/immutable values are 'valid'.
  #
  def valid?
    @val_immutable or (valid_val? and valid_in_row? and valid_in_col? and valid_in_grid?)
  end

  def val=(raw)
    fail if @val_immutable
    @val = raw
  end

  def to_s
    "{x:#{@x}; y:#{@y}; val:#{val}}"
  end

private
  def valid_val?
    @val =~ /\d+/
  end

  def valid_in_row?
    uniq_in?(row)
  end

  def valid_in_col?
    uniq_in?(col)
  end

  def valid_in_grid?
    uniq_in?(grid)
  end

  def self.uniq_in?(collection)
  end

end


if $0 == __FILE__
  require 'test/unit'

  class TestCell < Test::Unit::TestCase
    def setup
      @row = []
      @col = []
      @grid = []
    end
    def test_initial_val
      @cell = Cell.new(1, 1, @col, @row, @grid, 1234)
      assert @cell.valid?, "cell is valid when initialized w/ a value"
    end
  end

end
