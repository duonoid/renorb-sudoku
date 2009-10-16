#!/usr/bin/ruby

# Matrix is the entire puzzle.
#
class Matrix # TODO: split to separate file

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

    c = Cell.new(x, y, @cols[x], @rows[y], @grids[x/grid_size][y/grid_size], val)
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

# TODO: split to separate file
class Cell #########################

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

  def valid?
    valid_val? and valid_in_row? and valid_in_col? and valid_in_grid?
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

# when run interactively...
if $0 == __FILE__
  require 'stringio'
  require 'pp'

  matrix = Matrix.new(3)
  StringIO.new(<<-EOS
  . 6 .
  . 4 .
  . 3 .
  EOS
  ).readlines.each_with_index do |line, idx|
    line.chars.to_a.delete_if {|d| d.strip.empty? }.compact.each_with_index do |char, idx2|
      cell = matrix.cell(idx2, idx, char)
      puts cell
    end
  end

  puts "******** matrix:"
  puts matrix

end

