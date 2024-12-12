package day5

import "core:fmt"
import ts "core:container/topological_sort"
import "core:slice"
import "core:strings"
import "core:strconv"

edges :: #load("test_input.txt", string)

print :: fmt.println
main :: proc() {
    print("hihi")

    sorter : ts.Sorter(int)
    ts.init(&sorter)
    defer ts.destroy(&sorter)

    parse_input(edges, &sorter)
    result, _ := ts.sort(&sorter)
    // slice.reverse(result[:])
    // slice.is_sorted

    print(result)

}

parse_input :: proc(input: string, sorter: ^ts.Sorter(int)) {
    input := input
    for row in strings.split_lines_iterator(&input) {
        row := row
        nums : [2]int
        id := 0
        for element in strings.split_iterator(&row, "|") {
            val, ok := strconv.parse_int(element, 10)
            if !ok do panic("can't parse int")
            nums[id] = val
            id += 1
        }

        ts.add_key(sorter, nums[0])
        ts.add_key(sorter, nums[1])
        ts.add_dependency(sorter, nums[1], nums[0])
    }
}
