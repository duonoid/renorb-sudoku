require 'sudoku/architect'

module PencilMethod
  module MatrixModule
    def num_unsolved_cells
      retval = 0
      cells.each do |cell|
        cell.extend(PencilMethod::CellModule) unless cell.is_a? PencilMethod::CellModule
        retval += 1 unless cell.solved?
      end

      retval
    end
    def solve
      while num_unsolved_cells > 0 do
        cells.each do |cell|
          next if cell.immutable?
          grid_size.times do |t|
            $stderr.print"trying value: #{t} in #{cell} ..."
            cell.try_val t
            $stderr.puts "  possible values: #{cell.possible_vals.inspect}"
            sleep 0.25
          end
        end
      end
    end
  end

  module CellModule
    def try_val(raw)
      old_val = val
      @val = raw.to_s
      $stderr.print " old_val:#{old_val}; val:#{val}; reason:#{reason}"
      if valid?
        possible_vals << val
        possible_vals.uniq!
      end

      val = old_val
    end
    def possible_vals
      unless @possible_vals
        @possible_vals = []
        if immutable?
          @possible_vals << val
          @possible_vals.freeze
        end
      end

      @possible_vals
    end
    def solved?
      possible_vals.size == 1
    end
  end
end

# Knows how to solve sudoku.
#
module Solver

  # ==== Params
  # +matrix_to_solve+ pre-initialized matrix
  #
  # ==== Returns
  # solved matrix
  #
  def solve(matrix_to_solve)
    $stderr.puts "matrix, before:\n#{matrix_to_solve}"
    matrix_to_solve.extend(PencilMethod::MatrixModule)
    matrix_to_solve.solve

    matrix_to_solve
  end
  module_function :solve

end

if $0 == __FILE__
  include Sudoku

  matrix = Architect.matrix(STDIN)
  puts Solver.solve(matrix)
end
