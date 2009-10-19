require 'sudoku/cell'

module Sudoku

  # Matrix is the entire puzzle.
  #
  class Matrix

    attr_reader :grid_size, :width
    attr_reader :cells

    def initialize(matrix_width=9)
      @width = matrix_width
      if matrix_width == 3
        @grid_size = 3
      else
        @grid_size = Math.sqrt(matrix_width).to_i # TODO: fail if not an even square
      end

      @matrix = Hash.new {|hash, key| hash[key] = Hash.new }
      @cols = Hash.new {|h, k| h[k] = Array.new }
      @rows = Hash.new {|h, k| h[k] = Array.new }
      @grids = Hash.new do |h, k|
        h[k] = Hash.new {|h2, k2| h2[k2] = Array.new }
      end
      @cells = []
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

      c = Sudoku::Cell.new(x, y, @cols[x], @rows[y],
                           @grids[(x/grid_size).to_i][(y/grid_size).to_i],
                           val)
      @matrix[x][y] = c
      @cells << c

      c
    end

    def to_s
      @grids.each_key do |k|
        @grids[k].each_key do |k2|
          puts
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
    include Sudoku
    def setup
      @matrix = Matrix.new(3)
    end
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
    def test_cells_method
      @matrix.cell(0, 0)
      assert_equal 1, @matrix.cells.size
    end
  end

end
