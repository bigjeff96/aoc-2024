package day9

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 9")
    part_1()
    part_2()
}

part_1 :: proc() {
    data : [dynamic]int
    parse_input(input, &data)

    field : [dynamic]int
    id := 0
    is_block := true
    total_free := 0
    FREE :: -9
    for val in data {
        if is_block {
            for _ in 0..<val do append(&field, id)
            id += 1
            is_block = !is_block
        } else {
            for _ in 0..<val do append(&field, FREE)
            is_block = !is_block
            total_free += val
        }
    }

    id_first_free := 0
    for field[id_first_free] != FREE do id_first_free += 1
    id_last_block := len(field) - 1

    id_free := id_first_free
    id_block := id_last_block
    original_total_free := total_free

    len_free := 0
    tmp_id := len(field) - 1
    for total_free > 0 && id_free < len(field) && id_block >= 0 && len_free != original_total_free {
        slice.swap(field[:], id_free, id_block)
        total_free -= 1
        for field[id_free] != FREE do id_free += 1
        for field[id_block] == FREE do id_block -= 1
        len_free = len(field) - 1 - tmp_id
        for i := tmp_id; i >= 0; i -= 1 {
            if field[i] == FREE do len_free += 1
            else {
                tmp_id = i
                break
            }
        }
    }

    id_first_free = 0
    for field[id_first_free] != FREE do id_first_free += 1

    values := field[:id_first_free]
    answer := 0

    for v, id in values do answer += v*id
    print("Answer part 1:", answer)
}

part_2 :: proc() {
    answer := 0
    print("Answer part 2:", answer)
}

parse_input :: proc(input: string, data: ^[dynamic]int) {
    input := input
    is_block := true

    for i in 0..<len(input) {
        val, _ := strconv.parse_int(input[i:i+1], 10)
        append(data, val)
    }
}