
module Sudoku

  # Individual 'square' that you write a number in.
  #
  # Implements the basic rules of 'validity', according to Sudoku rules.
  #
  class Cell

    attr_reader :x, :y, :col, :row, :grid

    # If a +val+ is passed on initialization, consider it immutable.
    #
    # The cell adds itself to the appropriate col, row, and grid.
    #
    def initialize(x, y, col, row, grid, the_val=nil)
      @x = x; @y = y
      @col = col; @row = row; @grid = grid

      @col << self
      @row << self
      @grid << self

      @immutable = false
      unless the_val.nil?
        @val = the_val.to_s
        @immutable = true if valid_val?
      end
    end

    # All initial/immutable values are 'valid'.
    #
    def valid?
      @immutable or (valid_val? and valid_in_row? and valid_in_col? and valid_in_grid?)
    end

    def reason
      case
      when !valid_val?
        "invalid value: #{val.inspect}"
      when !valid_in_row?
        "invalid in row"
      when !valid_in_col?
        "invalid_in_col"
      end
    end

    def val
      @val
    end

    def val=(raw)
      fail 'value is immutable' if immutable?
      @val = raw.to_s
    end

    def immutable?
      !! @immutable
    end

    def to_s
      "{x:#{@x}; y:#{@y}; val:#{val}}"
    end

  private

    def valid_val?
      val =~ /\d+/ # TODO: grids > 9 sometimes use letters
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

    def uniq_in?(collection)
      cnt = collection.count {|c| c.val.to_i > 0 && c.val.to_i == @val.to_i }
      return true unless cnt > 1

      false
    end

  end

end


if $0 == __FILE__
  require 'test/unit'

  class TestCell < Test::Unit::TestCase
    include Sudoku
    def setup
      @row = []
      @col = []
      @grid = []

      cell1 = Cell.new(0, 0, @col, @row, @grid, 1)
      @row << cell1
      @col << cell1
      @grid << cell1

      @cell = Cell.new(0, 1, @col, @row, @grid)
    end
    def test_initial_val
      @cell = Cell.new(0, 1, @col, @row, @grid, 2)
      assert @cell.valid?, "cell is valid when initialized w/ a value"
    end
    def test_mutable_val
      @cell = Cell.new(0, 1, @col, @row, @grid, '.')
      assert !@cell.valid?, "cell isn't valid w/o valid char"
    end
    def test_invalid_val_in_row
      @cell.val = 1
      assert !@cell.__send__(:valid_in_row?)
    end
    def test_valid_val_in_row
      @cell.val = 2
      assert @cell.__send__(:valid_in_row?)
    end
    def test_setting_val
      @cell.val = 3
      assert_equal "3", @cell.val
      assert @cell.valid?
    end
  end

end
