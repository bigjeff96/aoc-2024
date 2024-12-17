package day8

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 8")
    part_1()
    part_2()
}

Lookup :: map[rune][dynamic][2]int

in_domain :: proc(pos: [2]int, dim: int) -> bool {
    for coord in pos {
        if coord < 0 {
            return false
        }
        if coord >= dim {
            return false
        }
    }
    return true
}

part_1 :: proc() {
    lookup := make(map[rune][dynamic][2]int)
    dim : int
    parse_input(input, &lookup, &dim)
    anti_nodes : map[[2]int]struct{}
    for _, positions in lookup {
        for i in 0..<len(positions) {
            for j in (i+1)..<len(positions) {
                pos_i := positions[i]
                pos_j := positions[j]

                anti_node_i := 2 * (pos_j - pos_i) + pos_i
                anti_node_j := 2 * (pos_i - pos_j) + pos_j

                if in_domain(anti_node_i, dim) do anti_nodes[anti_node_i] = {}
                if in_domain(anti_node_j, dim) do anti_nodes[anti_node_j] = {}
            }
        }
    }
    answer := len(anti_nodes)
    print("Answer part 1:", answer)
}

part_2 :: proc() {
    lookup := make(map[rune][dynamic][2]int)
    dim : int
    parse_input(input, &lookup, &dim)
    anti_nodes : map[[2]int]struct{}
    for _, positions in lookup {
        for i in 0..<len(positions) {
            for j in (i+1)..<len(positions) {
                pos_i := positions[i]
                pos_j := positions[j]

                vec_ij := (pos_j - pos_i)
                anti_node_i := pos_i
                for in_domain(anti_node_i, dim) {
                    anti_nodes[anti_node_i] = {}
                    anti_node_i += vec_ij
                }

                vec_ji := pos_i - pos_j
                anti_node_j := pos_j
                for in_domain(anti_node_j, dim) {
                    anti_nodes[anti_node_j] = {}
                    anti_node_j += vec_ji
                }
            }
        }
    }
    answer := len(anti_nodes)
    print("Answer part 2:", answer)
}

parse_input :: proc(input: string, lookup: ^Lookup, dim: ^int) {
    input := input
    i := 0
    for row in strings.split_lines_iterator(&input) {
        row := row
        dim^ = len(row)
        j := 0
        for e in row {
            if e != '.' {
                array, ok := &lookup[e]

                if !ok {
                    array := make([dynamic][2]int)
                    append(&array, [2]int{i, j})
                    lookup[e] = array
                } else {
                    append(array, [2]int{i,j})
                }
            }
            j += 1
        }
        i += 1
    }
}