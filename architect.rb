#!/usr/bin/ruby

require 'matrix'

module Architect

  # Creates a Matrix instance from +io+ stream.
  #
  def matrix(io, &blk)
    matrix = nil
    io.readlines.each_with_index do |line, idx|
      chars = line.chars.to_a.delete_if {|d| d.strip.empty? }.compact
      matrix ||= Matrix.new(chars.length)
      chars.each_with_index do |char, idx2|
        cell = matrix.cell(idx2, idx, char)
        yield cell if block_passed?
      end
    end

    matrix
  end
  module_function :matrix

end

# Architect knows how to construct the Matrix.
#

# when run interactively...
if $0 == __FILE__
  require 'pp'

  matrix = Architect.matrix(STDIN) {|cell| puts cell }

  puts "******** matrix:"
  puts matrix
end

