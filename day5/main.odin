package day5

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

edges :: #load("input.txt", string)

print :: fmt.println
main :: proc() {
    print("Day 5")
    part_1()
    part_2()

}

part_1 :: proc() {
    lists := make([dynamic][dynamic]int)
    lookup := make(map[int][dynamic]int)
    parse_input(edges, &lookup, &lists)
    for _, array in lookup {
        slice.sort(array[:])
    }
    sum := 0
    for list in lists {
        is_sorted := true
        outer: for i in 0..<len(list) {
            key := list[i]
            array := lookup[key]
            for j in (i+1)..<len(list) {
                comp := list[j]
                _, found := slice.binary_search(array[:], comp)
                if !found {
                    is_sorted = false
                    break outer
                }
            }
        }

        if is_sorted {
            sum += list[len(list) / 2]
        }
    }

    print("Answer part 1:", sum)
}

part_2 :: proc() {
    lists := make([dynamic][dynamic]int)
    lookup := make(map[int][dynamic]int)
    parse_input(edges, &lookup, &lists)
    for _, array in lookup {
        slice.sort(array[:])
    }
    sum := 0
    context.user_ptr = &lookup
    for &list in lists {
        is_sorted := true
        outer: for i in 0..<len(list) {
            key := list[i]
            array := lookup[key]
            for j in (i+1)..<len(list) {
                comp := list[j]
                _, found := slice.binary_search(array[:], comp)
                if !found {
                    is_sorted = false
                    break outer
                }
            }
        }

        if !is_sorted {
            // use the context to apply a sort_by function on the list
            slice.sort_by(list[:], proc(i,j: int) -> bool {
                lookup := cast(^map[int][dynamic]int) context.user_ptr
                array_i := lookup[i]
                _, found := slice.binary_search(array_i[:], j)
                if found do return true
                else do return false
            })

            sum += list[len(list) / 2]
        }
    }

    print("Answer part 2:", sum)
}

parse_input :: proc(input: string, lookup: ^map[int][dynamic]int, lists: ^[dynamic][dynamic]int) {
    input := input
    blank := false
    for row in strings.split_lines_iterator(&input) {
        row := row
        if len(row) == 0 {
            blank = true
            continue
        }
        if !blank {
            nums : [2]int
            id := 0
            for element in strings.split_iterator(&row, "|") {
                val, ok := strconv.parse_int(element, 10)
                if !ok do panic("can't parse int")
                nums[id] = val
                id += 1
            }
            ok := nums[0] in lookup
            if !ok {
                array := make([dynamic]int)
                append(&array, nums[1])
                lookup[nums[0]] = array
            } else {
                array := lookup[nums[0]]
                append(&array, nums[1])
                lookup[nums[0]] = array
            }

        } else {
            list := make([dynamic]int)
            for str in strings.split_iterator(&row, ",") {
                val, ok := strconv.parse_int(str, 10)
                if !ok do panic("can't parse int")
                append(&list, val)
            }
            append(lists, list)
        }
    }
}
