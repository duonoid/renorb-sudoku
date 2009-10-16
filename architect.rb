#!/usr/bin/ruby

require 'matrix'

# Architect knows how to construct the Matrix.
#

# when run interactively...
if $0 == __FILE__
  require 'pp'

  matrix = Matrix.new(3)
  STDIN.readlines.each_with_index do |line, idx|
    line.chars.to_a.delete_if {|d| d.strip.empty? }.compact.each_with_index do |char, idx2|
      cell = matrix.cell(idx2, idx, char)
      puts cell
    end
  end

  puts "******** matrix:"
  puts matrix

end

