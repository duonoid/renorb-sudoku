require 'sudoku/architect'

module PencilMethod
  module MatrixModule
    def unsolved_cells
      cells.collect do |cell|
        cell.extend(PencilMethod::CellModule) unless cell.is_a? PencilMethod::CellModule
        next cell unless cell.solved?
      end.compact
    end
    def solve
      # initialization
      unsolved_cells.each do |cell|
        next if cell.immutable?
        width.times do |t|
          val = t + 1
          cell.try_val val
          if $VERBOSE
            $stderr.print"[#{cell.x}, #{cell.y}] trying value: #{val} ... "
            $stderr.puts (cell.was_valid? ? "valid! current possibilities: #{cell.possible_vals.inspect}" : "invalid: #{cell.last_reason}")
            sleep 0.1
          end
        end
      end

      # iteration
      loop do
        break if unsolved_cells.size == 0

        min_solution_size = width

        unsolved_cells.each do |cell|
          $stderr.print "solving [#{cell.x}, #{cell.y}] ... checking:" if $VERBOSE
          cell.possible_vals.each do |poss_val|
            cell.try_val poss_val
            $stderr.print " #{poss_val}(#{cell.was_valid? ? 'valid' : cell.last_reason})" if $VERBOSE
          end
          $stderr.puts " current possibilities: #{cell.possible_vals.inspect}" if $VERBOSE

          if cell.solved?
            cell.val = cell.possible_vals.first
            $stderr.puts "**** [#{cell.x}, #{cell.y}] solved!  value: #{cell.val}"
            cell.done!
          end

          pvsize = cell.possible_vals.size
          if pvsize > 0 && pvsize < min_solution_size
            min_solution_size = pvsize
          end

          sleep 0.1 if $VERBOSE
        end
        if min_solution_size > 1
          $stderr.puts "*** WARNING: minimum solution size: #{min_solution_size}" # TODO: branch point: multiple solutions possible
          branches = unsolved_cells.collect do |cell|
            if cell.possible_vals.size == min_solution_size
              $stderr.puts "[#{cell.x}, #{cell.y}] possible: #{cell.possible_vals.join(',')}]"
              next cell
            end
          end.compact
          $stderr.puts "  trying ambiguous solution"
          branches.first.val = branches.first.possible_vals.first
          branches.first.possible_vals.delete branches.first.val
        end
      end
    end
  end

  module CellModule
    def done!
      @immutable = true
    end
    def last_reason
      @last_reason
    end
    def was_valid?
      !! @was_valid
    end
    def try_val(raw)
      old_val = val
      @val = raw.to_s
      @was_valid = valid?
      if @was_valid
        possible_vals << val
        possible_vals.uniq!
      else
        possible_vals.delete(val) if valid_val?
      end
      @last_reason = reason

      @val = old_val
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
      if possible_vals.size == 1
        @val = possible_vals.first.to_s
        return true
      end

      false
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
