#!/usr/bin/ruby

require 'sudoku/matrix'

module Sudoku
  module Architect

    # Creates a Matrix instance from +io+ stream.
    #
    def matrix(io, &blk)
      matrix = nil
      io.readlines.each_with_index do |line, idx|
        chars = line.chars.to_a.delete_if {|d| d.strip.empty? }.compact
        matrix ||= ::Sudoku::Matrix.new(chars.length)
        chars.each_with_index do |char, idx2|
          cell = matrix.cell(idx2, idx, char)
          yield cell if block_given?
        end
      end

      matrix
    end
    module_function :matrix

  end
end

# Architect knows how to construct the Matrix.
#

# when run interactively...
if $0 == __FILE__
  require 'pp'

  matrix = Sudoku::Architect.matrix(STDIN) {|cell| puts cell }

  puts "******** matrix:"
  puts matrix
end

