require 'sudoku/architect'

# Knows how to solve sudoku.
#
module Solver

  # ==== Returns
  # solved matrix
  #
  def solve(matrix_to_solve)
    matrix_to_solve
  end
  module_function :solve

end

if $0 == __FILE__
  include Sudoku

  matrix = Architect.matrix(STDIN)
  puts Solver.solve(matrix)
end
