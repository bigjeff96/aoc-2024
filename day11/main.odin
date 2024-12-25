package day11

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("test_input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 11")
    part_1()
    part_2()
}

part_1 :: proc() {
    parse_input(input)
    answer := 0
    print("Answer part 1:", answer)
}

part_2 :: proc() {
    answer := 0
    print("Answer part 2:", answer)
}

parse_input :: proc(input: string) {
    input := input

    for row in strings.split_lines_iterator(&input) {
        row := row
        for e in row {
            print(e)
        }
    }
}