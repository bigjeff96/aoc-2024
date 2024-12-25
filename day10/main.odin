package day10

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 10")
    part_1()
    part_2()
}

part_1 :: proc() {
    mat := parse_input(input)
    dim := len(mat[0])

    zeros : [dynamic][2]int

    for i in 0..<dim do for j in 0..<dim {
        v := mat[i][j]
        if v == 0 do append(&zeros, [2]int{i, j})
    }

    answer := 0
    for zero in zeros {
        unique_nines := make(map[[2]int]struct{}, 5, context.temp_allocator)
        depth_first_search :: proc(mat: [dynamic][dynamic]int,
                                   position: [2]int,
                                   unique_nines: ^map[[2]int]struct{})
        {
            if mat[position.x][position.y] == 9 {
                unique_nines[position] = {}
                return
            }

            dim := len(mat[0])
            current_value := mat[position.x][position.y]

            up_pos := position + {-1, 0}
            down_pos := position + {+1, 0}
            left_pos := position + {0, -1}
            right_pos := position + {0, +1}

            poses := [4][2]int{up_pos, down_pos, left_pos, right_pos}

            for pos in poses {
                in_range := pos.x >= 0 && pos.x < dim && pos.y >= 0 && pos.y < dim
                if in_range && mat[pos.x][pos.y] == current_value + 1 {
                    depth_first_search(mat, pos, unique_nines)
                }
            }
        }

        depth_first_search(mat, zero, &unique_nines)
        answer += len(unique_nines)
        free_all(context.temp_allocator)
    }

    print("Answer part 1:", answer)
}

id_to_direction := [4]byte{'u', 'd', 'l', 'r'}

part_2 :: proc() {
    mat := parse_input(input)
    dim := len(mat[0])

    zeros : [dynamic][2]int

    for i in 0..<dim do for j in 0..<dim {
        v := mat[i][j]
        if v == 0 do append(&zeros, [2]int{i, j})
    }

    answer := 0
    for zero in zeros {
        unique_nines := make(map[string]struct{}, 5, context.temp_allocator)
        depth_first_search :: proc(mat: [dynamic][dynamic]int,
                                   position: [2]int,
                                   builder: ^strings.Builder,
                                   unique_nines: ^map[string]struct{})
        {
            if mat[position.x][position.y] == 9 {
                str := strings.to_string(builder^)
                unique_nines[str] = {}
                return
            }

            dim := len(mat[0])
            current_value := mat[position.x][position.y]

            up_pos := position + {-1, 0}
            down_pos := position + {+1, 0}
            left_pos := position + {0, -1}
            right_pos := position + {0, +1}

            poses := [4][2]int{up_pos, down_pos, left_pos, right_pos}

            for pos, i in poses {
                in_range := pos.x >= 0 && pos.x < dim && pos.y >= 0 && pos.y < dim
                if in_range && mat[pos.x][pos.y] == current_value + 1 {
                    data := slice.clone_to_dynamic(builder.buf[:], context.temp_allocator)
                    new_builder := strings.Builder{data}
                    strings.write_byte(&new_builder, id_to_direction[i])
                    depth_first_search(mat, pos, &new_builder, unique_nines)
                }
            }
        }
        builder := strings.builder_make(context.temp_allocator)
        depth_first_search(mat, zero, &builder, &unique_nines)
        answer += len(unique_nines)
        free_all(context.temp_allocator)
    }

    print("Answer part 2:", answer)
}

parse_input :: proc(input: string) -> (mat: [dynamic][dynamic]int) {
    input := input

    for row in strings.split_lines_iterator(&input) {
        row := row
        array := make([dynamic]int)
        for i in 0..<len(row) {
            e := row[i:i+1]
            v := strconv.atoi(e)
            append(&array, v)
        }
        append(&mat, array)
    }
    return
}