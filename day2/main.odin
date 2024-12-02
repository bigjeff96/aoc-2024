package day2

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

input_data :: #load("input.txt")

print :: fmt.println

main :: proc() {
    print("Day 2")
    part_1()
    part_2()
}

part_1 :: proc() {
    input := string(input_data)
    rows : [dynamic][dynamic]int
    id := 0
    for row in strings.split_lines_iterator(&input) {
        row := row
        row_mem := make([dynamic]int)
        append(&rows, row_mem)
        for element in strings.fields_iterator(&row) {
            val, ok := strconv.parse_int(element, 10)
            if !ok do panic("can't parse int")
            append(&rows[id], val)
        }
        id += 1
    }
    count_sorted := 0
    for row in rows {
        is_ascending, is_descending := test(row[:])
        if is_ascending || is_descending do count_sorted += 1
    }
    print("- Answer part 1:", count_sorted)
}

part_2 :: proc() {
    input := string(input_data)
    rows : [dynamic][dynamic]int
    id := 0
    for row in strings.split_lines_iterator(&input) {
        row := row
        row_mem := make([dynamic]int)
        append(&rows, row_mem)
        for element in strings.fields_iterator(&row) {
            val, ok := strconv.parse_int(element, 10)
            if !ok do panic("can't parse int")
            append(&rows[id], val)
        }
        id += 1
    }

    count_sorted := 0
    rows_to_fix : [dynamic]int
    for row, id in rows {
        is_ascending, is_descending := test(row[:])

        if is_ascending || is_descending do count_sorted += 1
        else if !is_ascending && !is_descending do append(&rows_to_fix, id)
    }

    for id_row_to_fix in rows_to_fix {
        row := rows[id_row_to_fix]
        for i in 0..<len(row) {
            row_mod := slice.clone_to_dynamic(row[:], context.temp_allocator)
            ordered_remove(&row_mod, i)

            ascending, descending := test(row_mod[:])

            if ascending || descending {
                count_sorted += 1
                break
            }
        }
        free_all(context.temp_allocator)
    }
    print("- Answer part 2:", count_sorted)
}

test :: proc(row: []int) -> (ascending: bool, descending: bool) {
    ascending = true
    descending = true

    for i in 1..<len(row) {
        a := row[i - 1]
        b := row[i]
        if a < b && abs(a - b) >= 1 && abs(a - b) <= 3 do continue
        else {
            ascending = false
            break
        }
    }

    for i in 1..<len(row) {
        a := row[i - 1]
        b := row[i]
        if a > b && abs(a - b) >= 1 && abs(a - b) <= 3 do continue
        else {
            descending = false
            break
        }
    }

    return
}

