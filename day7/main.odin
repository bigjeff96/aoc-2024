package day7

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:math/bits"

input :: #load("input.txt", string)

extract :: bits.bitfield_extract_u64

print :: fmt.println

main :: proc() {
    print("Day 7")
    part_1()
    part_2()
}

part_1 :: proc() {
    totals := make([dynamic]int)
    lists := make([dynamic][dynamic]int)
    parse_input(input, &totals, &lists)

    answer := 0

    for total, id in totals {
        nums := lists[id]
        result := 0
        total_combinations : u64 = auto_cast math.pow(2.0, f64( len(nums) - 1))
        totals := len(nums) - 1
        works := false
        for i: u64 = 0; i < total_combinations; i += 1 {
            result = nums[0]
            for bit in 0..<totals {
                symbol := extract(i, auto_cast bit, 1)
                if symbol == 0 {
                    // plus
                    result += nums[bit+1]
                } else {
                    // multiply
                    result *= nums[bit+1]
                }
            }

            if result == total {
                works = true
                break
            }
        }

        if works do answer += total
    }

    print("Answer part 1:", answer)
}

part_2 :: proc() {
    totals := make([dynamic]int)
    lists := make([dynamic][dynamic]int)
    parse_input(input, &totals, &lists)

    answer :u64= 0

    for total, id in totals {
        nums := lists[id]
        result :u64= 0
        total_combinations : u64 = auto_cast math.pow(3.0, f64( len(nums) - 1))
        total_symbols := len(nums) - 1
        buffer : [50]int
        symbol_table := buffer[:total_symbols]
        for i in 0..<total_symbols do symbol_table[i] = -1

        increment_symbol_table :: proc(symbol_table: []int) {
            id := 0
            for {
                if symbol_table[id] < 1 {
                    symbol_table[id] += 1
                    break
                }
                else {
                    symbol_table[id] = -1
                    id += 1
                }
            }
        }

        works := false

        outer: for i: u64 = 0; i < total_combinations; i += 1 {
            if i > 0 do increment_symbol_table(symbol_table[:])
            result = auto_cast nums[0]
            for symbol, bit in symbol_table {
                if symbol == -1 {
                    // plus
                    result += auto_cast nums[bit+1]
                } else if symbol == 0 {
                    // multiply
                    result *= auto_cast nums[bit+1]
                } else if symbol == 1 {
                    // concat
                    a := int(math.log10_f64(auto_cast nums[bit+1]) + 1)
                    result = result * u64(math.pow_f64(10.0, auto_cast a)) + auto_cast nums[bit+1]
                }

                if result > auto_cast total do continue outer
            }

            if result == auto_cast total {
                works = true
                break
            }
        }

        if works do answer += auto_cast total
    }
    print("Answer part 2:", answer)
}

parse_input :: proc(input: string, totals: ^[dynamic]int, lists: ^[dynamic][dynamic]int) {
    input := input
    for row in strings.split_lines_iterator(&input) {
        row := row
        list := make([dynamic]int)
        for e in strings.fields_iterator(&row) {
            if e[len(e)-1] == ':' {
                val, ok := strconv.parse_int(e[:len(e)-1], 10)
                append(totals, val)
            } else {
                val, ok := strconv.parse_int(e, 10)
                append(&list, val)
            }
        }
        append(lists, list)
    }
}