require 'architest'

# Knows how to solve sudoku.
#
class Solver

  attr_reader :matrix

  # ==== Params
  # +matrix_to_solve+ pre-initialized matrix
  #
  def initialize(matrix_to_solve)
    @matrix = matrix_to_solve
  end

  # ==== Returns
  # solved matrix
  #
  def solution
    @matrix
  end

end

if $0 == __FILE__
  matrix = Architect.new(STDIN)
  puts Solver.new(matrix).solution
end
