#Puzzle 20002
BOARD = Array(Int8[4,2,8,0,0,0,0,0,0,9,0,0,0,0,7,0,0,0,0,0,0,4,0,0,0,0,5,0,0,0,0,0,0,5,6,2])

function count(mylist,thing)
    output = 0
    for i in mylist
        if i == thing
            output += 1
            end 
    end
    output
end

NUMS = collect(1:9)
NUMBLANKS = count(BOARD,0)
#print(NUMBLANKS)

function populate_board(solution_board)
    output = deepcopy(BOARD)
    ind = 1
    for i in 1:36
        if output[i] == 0
            output[i] = solution_board[ind]
            ind +=1 
        end
    end
    output
end

function row(board,n)
    #returns values in row n of board
    return board[6*n-5:6*n]
end

function col(board,n)
    #returns values in col n of board
    if n == 6
        return [board[i] for i in [6,12,18,24,30,36]]
    else
        return [board[i] for i in 1:36 if i%6 == n]
    end
end

function quadrant(board,n)
    q = [[1,2,3,7,8,9,13,14,15],[4,5,6,10,11,12,16,17,18],[19,20,21,25,26,27,31,32,33],[22,23,24,28,29,30,34,35,36]]
    return [board[i] for i in q[n]]
end
            
function repeat(mylist)
    for n in mylist
        if n != 0 && count(mylist,n)>1
            return true
        end
    end
    return false
                
end

function print_board(solution_board)
    #board = populate_board(solution_board)

    print()
    for i in 1:36
        if i % 6 == 0
            println(solution_board[i])
        else
            print(solution_board[i])
            print(' ')
        end
    end
    println() #blank line
end

function check_no_conflicts(solution_board)
    #Returns False if there ARE conflicts
    for j in 1:6
        this_row = row(solution_board,j)
        if repeat(this_row)
            #println("repeat row",j)
            return false
        end
        if count(this_row,0) == 0 && sum(this_row) != 30
            return false
        end
        this_col = col(solution_board,j)
        #println("col count 0's ",count(this_col,0))
        if repeat(this_col)
            #println("repeat col",j)
            return false
        end
        if (count(this_col,0) == 0) && (sum(this_col) != 30)
            #println("col sum",j)
            return false
        end
    end
    for i in 1:4
        this_quad = quadrant(solution_board,i)
        if repeat(this_quad)
            return false
        end
        for j in 1:9
            if count(this_quad,0) == 0 && count(this_quad,j) != 1
                #println("quad",n)
                return false
            end
        end
    end
    return true
end

function solve(values, size)
    solution_list = zeros(size)

    function extend_solution(position)
        for value in values
            solution_list[position] = value
            solution = populate_board(solution_list)
            print_board(solution)
            if check_no_conflicts(solution)
                if position >= size || (extend_solution(position+1) != nothing)
                    return solution
                end
                
            else
                solution_list[position] = 0
                if position < size
                    solution_list[position+1] = 0
                end
                if value == values[length(values)]
                    #println("end of values")
                    if position > 1
                        solution_list[position-1] = 0
                    end
                end
                
            end
        end

        nothing
    end
    return extend_solution(1)
end

#board1 = create_board(BOARD)
#print_board(board1)

soln = solve(NUMS,NUMBLANKS)
println(soln)
print_board(soln)