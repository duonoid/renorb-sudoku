require 'sudoku/cell'

module Sudoku

  # Matrix is the entire puzzle.
  #
  class Matrix

    attr_reader :grid_size

    def initialize(matrix_width=9)
      if matrix_width == 3
        @grid_size = 3
      else
        @grid_size = Math.sqrt(matrix_width) # TODO: fail if not an even square
      end

      @matrix = Hash.new {|hash, key| hash[key] = Hash.new }
      @cols = Hash.new {|h, k| h[k] = Array.new }
      @rows = Hash.new {|h, k| h[k] = Array.new }
      @grids = Hash.new do |h, k|
        h[k] = Hash.new {|h2, k2| h2[k2] = Array.new }
      end
    end

    # Creates or returns an existing Cell.
    #
    # ==== Params
    # +x+ - Cell's index in the Matrix, 0 based
    # +y+
    # +val+ - Cell's value
    #
    def cell(x, y, val=nil)
      if c = @matrix[x][y]
        return c
      end

      c = Sudoku::Cell.new(x, y, @cols[x], @rows[y], @grids[x/grid_size][y/grid_size], val)
      @matrix[x][y] = c

      c
    end

    def to_s
      @grids.each_key do |k|
        @grids[k].each_key do |k2|
          puts "grid: #{k2}:#{k}"
          print @grids[k2][k] # works by side-effect of being square...
          print " "
        end
        print "\n"
      end
    end

  end

end

if $0 == __FILE__
  require 'test/unit'

  class TestMatrix < Test::Unit::TestCase
    def test_grid_size_3
      matrix = Sudoku::Matrix.new(3)
      assert_equal 3, matrix.grid_size
    end
    def test_grid_size_9
      matrix = Sudoku::Matrix.new(9)
      assert_equal 3, matrix.grid_size
    end
    def test_grid_size_25
      matrix = Sudoku::Matrix.new(25)
      assert_equal 5, matrix.grid_size
    end
  end

end
