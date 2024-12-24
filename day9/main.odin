package day9

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

input :: #load("input.txt", string)

print :: fmt.println
FREE :: -9

main :: proc() {
    print("Day 9")
    part_1()
    part_2()
}

make_the_field :: proc(data: [dynamic]int) -> (field: [dynamic]int, total_free: int) {
    id := 0
    is_block := true
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
    return
}

part_1 :: proc() {
    data : [dynamic]int
    parse_input(input, &data)
    field, total_free := make_the_field(data)

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
    data : [dynamic]int
    parse_input(input, &data)
    field, total_free := make_the_field(data)

    // hold in memory the ranges of free domains and values
    free_domains : [dynamic][2]int
    value_domains : [dynamic][2]int

    start_id := 0
    current_id := start_id
    for current_id < len(field) {
        v := field[current_id]
        switch v {
        case FREE:
            values_start := start_id
            for current_id < len(field) && field[current_id] == FREE do current_id += 1
            values_end := current_id
            append(&free_domains, [2]int{values_start, values_end})
        case:
            values_start := start_id
            type := field[current_id]
            for current_id < len(field) && field[current_id] == type do current_id += 1
            values_end := current_id
            append(&value_domains, [2]int{values_start, values_end})
        }
        start_id = current_id
    }
    slice.reverse(value_domains[:])

    values := value_domains[:]
    frees := free_domains[:]

    for len(values) > 0 {
        value_range := values[0]
        length_v_range := value_range[1] - value_range[0]

        it_fits := false
        id_it_fits := 0
        for free_range, id in frees {
            length_f_range := free_range[1] - free_range[0]
            if length_v_range <= length_f_range && free_range[0] < value_range[0] {
                it_fits = true
                id_it_fits = id
                break
            }
        }

        if it_fits {
            free_range := &frees[id_it_fits]
            length_f_range := free_range[1] - free_range[0]
            start := free_range[0]
            for id := value_range[0]; id < value_range[1]; id += 1 {
                slice.swap(field[:], id, start)
                start += 1
            }

            if length_f_range == length_v_range do free_range[1] = free_range[0]
            else do free_range[0] += length_v_range
        }
        values = values[1:]
    }

    answer := 0
    for v, id in field do if v != FREE {
        answer += id * v
    }
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