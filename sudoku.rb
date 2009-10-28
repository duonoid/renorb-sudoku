#!/usr/bin/ruby

require 'matrix'
require 'cell'

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

