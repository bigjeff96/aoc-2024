package day5

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

map_input :: #load("input.txt", string)

Blocked :: struct {}
Free :: struct {
    visited: bool,
    set: bit_set[Direction]
}

Cell :: union {
    Blocked,
    Free,
}

Direction :: enum {
    up,
    down,
    left,
    right,
}

print :: fmt.println

main :: proc() {
    print("Day 6")
    part_1()
    part_2()

}

rotate_90 :: proc(orientation: [2]int) -> [2]int {
    return {orientation.y, -orientation.x}
}

orient_to_direction :: proc(orient: [2]int) -> Direction {
    switch orient {
    case {-1,0}: return .up
    case {0,1}: return .right
    case {1,0}: return .down
    case {0,-1}: return .left
    }
    return .up
}

part_1 :: proc() {
    mat := make([dynamic][dynamic]Cell)
    guard_pos : [2]int
    parse_input(map_input, &mat, &guard_pos)
    orientation := [?]int{-1, 0}
    dim := len(mat)

    for {
        next_pos := guard_pos + orientation
        valid_pos_test := next_pos.x >= 0 &&
                          next_pos.x < dim &&
                          next_pos.y >= 0 &&
                          next_pos.y < dim
        if !valid_pos_test do break
        next_cell := &mat[next_pos.x][next_pos.y]

        switch &cell in next_cell {
        case Blocked:
            orientation = rotate_90(orientation)
        case Free:
            cell.visited |= true
            guard_pos = next_pos
        }
    }
    sum := 0
    for i in 0..<dim {
        for j in 0..<dim {
            cell := mat[i][j]

            #partial switch v in cell {
            case Free:
                if v.visited do sum += 1
            }
        }
    }

    print("Answer part 1:", sum)
}

part_2 :: proc() {
    mat := make([dynamic][dynamic]Cell)
    guard_pos : [2]int
    parse_input(map_input, &mat, &guard_pos)

    guard_start_pos := guard_pos
    orientation := [2]int{-1, 0}
    dim := len(mat)

    sum := 0
    for i in 0..<dim {
        for j in 0..<dim {
            cell := &mat[i][j]
            #partial switch &v in cell {
            case Blocked: continue
            }

            if i == guard_start_pos.x && j == guard_start_pos.y do continue

            mat[i][j] = Blocked{}
            in_a_loop := false
            guard_pos := guard_start_pos
            orientation := [2]int{-1 , 0}

            outer: for {
                next_pos := guard_pos + orientation
                valid_pos_test := next_pos.x >= 0 &&
                                  next_pos.x < dim &&
                                  next_pos.y >= 0 &&
                                  next_pos.y < dim
                if !valid_pos_test do break
                next_cell := &mat[next_pos.x][next_pos.y]

                switch &cell in next_cell {
                case Blocked:
                    orientation = rotate_90(orientation)
                case Free:
                    set := cell.set
                    direction := orient_to_direction(orientation)

                    if direction in set {
                        in_a_loop = true
                        break outer
                    } else {
                        set += {direction}
                        cell.set = set
                    }

                    guard_pos = next_pos
                }
            }

            mat[i][j] = Free{}
            if in_a_loop do sum += 1

            for i in 0..<dim do for j in 0..<dim {
                cell := &mat[i][j]
                #partial switch &v in cell {
                case Free: v.set = {}
                }

            }
        }
    }

    print("Answer part 2:", sum)
}

parse_input :: proc(input: string, mat: ^[dynamic][dynamic]Cell, guard_pos: ^[2]int) {
    input := input
    blank := false
    i := 0
    for row in strings.split_lines_iterator(&input) {
        line := make([dynamic]Cell)
        j := 0
        for str_cell in row {
            switch str_cell {
            case '.': append(&line, Free{})
            case '#': append(&line, Blocked{})
            case '^':
                guard_pos.x = i
                guard_pos.y = j
                append(&line, Free{visited = true})
            }
            j += 1
        }
        append(mat, line)
        i += 1
    }
}
