#!/usr/bin/ruby

require 'sudoku/matrix'

module Sudoku
  module Architect

    # Creates a Matrix instance from +io+ stream.
    #
    def matrix(io, &blk)
      matrix = nil
      idx = 0
      io.readlines.each do |line|
        next if line.strip.empty?
        chars = line.chars.to_a.delete_if {|d| d.strip.empty? }.compact
        matrix ||= ::Sudoku::Matrix.new(chars.length)
        chars.each_with_index do |char, idx2|
          $stderr.puts "building cell: idx2:#{idx2}; idx:#{idx}; char:#{char}" if $DEBUG
          cell = matrix.cell(idx2, idx, char)
          yield cell if block_given?
        end

        idx += 1
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

