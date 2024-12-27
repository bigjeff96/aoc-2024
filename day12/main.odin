package day12

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 12")
    part_1()
    part_2()
}

Direction :: enum {
    up,
    down,
    left,
    right,
}

Border_cell :: struct {
    i, j: int,
    direction: Direction,
}

id_to_direction := [4]Direction{.up, .down, .left, .right}

explore :: proc(mat: [dynamic][dynamic]rune,
                pos: [2]int,
                type: rune,
                cells: ^map[[2]int]struct{},
                border_cells: ^map[Border_cell]struct{})
{
    cells[pos] = {}
    up := pos + {-1, 0}
    down := pos + {1, 0}
    left := pos + {0, 1}
    right := pos + {0, -1}

    positions := [4][2]int{up, down, left, right}
    dim := len(mat[0])

    for key, id in positions {
        in_range := key.x >= 0 && key.x < dim && key.y >= 0 && key.y < dim
        if !in_range {
            border_cells[{key.x, key.y, id_to_direction[id]}] = {}
            continue
        }
        neighbor_type := mat[key.x][key.y]
        if neighbor_type != type {
            border_cells[{key.x, key.y, id_to_direction[id]}] = {}
            continue
        } else {
            if key not_in cells {
                explore(mat, key, type, cells, border_cells)
            }
        }
    }
}

part_1 :: proc() {
    mat := parse_input(input)
    seen_cells : map[[2]int]struct{}
    dim := len(mat[0])
    answer := 0
    for i in 0..<dim do for j in 0..<dim {
        v := mat[i][j]
        key := [2]int{i, j}
        if key not_in seen_cells {
            cells := make(map[[2]int]struct{}, 5, context.temp_allocator)
            border_cells := make(map[Border_cell]struct{}, 5, context.temp_allocator)
            defer {
                for k,_ in cells do seen_cells[k] = {}
                free_all(context.temp_allocator)
            }

            explore(mat, key, v, &cells, &border_cells)
            answer += len(cells) * len(border_cells)
        }
    }

    print("Answer part 1:", answer)
}

part_2 :: proc() {
    mat := parse_input(input)
    seen_cells : map[[2]int]struct{}
    dim := len(mat[0])
    answer := 0
    for i in 0..<dim do for j in 0..<dim {
        v := mat[i][j]
        key := [2]int{i, j}
        if key not_in seen_cells {
            cells := make(map[[2]int]struct{}, 5, context.temp_allocator)
            border_cells := make(map[Border_cell]struct{}, 5, context.temp_allocator)
            defer {
                for k,_ in cells do seen_cells[k] = {}
                free_all(context.temp_allocator)
            }

            explore(mat, key, v, &cells, &border_cells)

            total_sides := 0
            grouped_by_side := make(map[Direction][dynamic][2]int, 5, context.temp_allocator)

            // For anyone that reads this, this is a cluster fuck
            for side in Direction {
                array := make([dynamic][2]int, context.temp_allocator)
                grouped_by_side[side] = array
            }

            for side in Direction {
                for cell in border_cells do if cell.direction == side {
                    array := &grouped_by_side[side]
                    append(array, [2]int{cell.i, cell.j})
                }
            }

            for side in Direction {
                cells_by_rc := make(map[int][dynamic][2]int)
                cells_of_direction := grouped_by_side[side]

                for cell in cells_of_direction {
                    switch side {
                    case .up, .down:
                        ok := cell.x in cells_by_rc
                        if !ok {
                            array := make([dynamic][2]int, context.temp_allocator)
                            append(&array, cell)
                            cells_by_rc[cell.x] = array
                        } else {
                            array := cells_by_rc[cell.x]
                            append(&array, cell)
                            cells_by_rc[cell.x] = array
                        }
                    case .left, .right:
                        ok := cell.y in cells_by_rc
                        if !ok {
                            array := make([dynamic][2]int, context.temp_allocator)
                            append(&array, cell)
                            cells_by_rc[cell.y] = array
                        } else {
                            array := cells_by_rc[cell.y]
                            append(&array, cell)
                            cells_by_rc[cell.y] = array
                        }
                    }
                }

                for rc, cells_by_side in cells_by_rc {
                    if len(cells_by_side) > 0 do total_sides += 1
                    switch side {
                    case .up, .down:
                        slice.sort_by(cells_by_side[:], proc(a,b: [2]int) -> bool {
                            return a.y < b.y
                        })
                    case .left, .right:
                        slice.sort_by(cells_by_side[:], proc(a,b: [2]int) -> bool {
                            return a.x < b.x
                        })
                    }

                    switch side {
                    case .up, .down:
                        for i in 0..<(len(cells_by_side) -1) {
                            cell_a := cells_by_side[i]
                            cell_b := cells_by_side[i+1]
                            if cell_a.y == cell_b.y - 1 do continue
                            else do total_sides += 1
                        }

                    case .left, .right:
                        for i in 0..<(len(cells_by_side) -1) {
                            cell_a := cells_by_side[i]
                            cell_b := cells_by_side[i+1]
                            if cell_a.x == cell_b.x - 1 do continue
                            else do total_sides += 1
                        }
                    }
                }
            }

            answer += len(cells) * total_sides
        }
    }

    print("Answer part 2:", answer)
}

parse_input :: proc(input: string) -> (mat: [dynamic][dynamic]rune) {
    input := input

    for row in strings.split_lines_iterator(&input) {
        row := row
        array := make([dynamic]rune)
        for e in row do append(&array, e)
        append(&mat, array)
    }
    return
}