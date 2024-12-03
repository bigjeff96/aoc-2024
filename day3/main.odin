package day3

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

input_data :: #load("test.txt")
input_data_b :: #load("test2.txt")

print :: fmt.println

main :: proc() {
    print("Day 3")
    part_1()
    part_2()
}

part_1 :: proc() {
    sum := 0
    input := string(input_data)
    for row in strings.split_lines_iterator(&input) {
        row := row
        vals: [2]int
        id := 0
        for element in strings.fields_iterator(&row) {
            val, ok := strconv.parse_int(element, 10)
            if !ok do panic("can't parse int")
            vals[id] = val
            id += 1
        }

        sum += vals[0] * vals[1]
    }
    print("Answer part 1:", sum)
}

part_2 :: proc() {
    sum := 0
    input := string(input_data_b)
    ok := true
    for row in strings.split_lines_iterator(&input) {
        row := row
        vals: [2]int

        if row == "yes" do ok = true
        else if row == "no" do ok = false
        else if ok {
            id := 0
            for element in strings.fields_iterator(&row) {
                val, ok := strconv.parse_int(element, 10)
                if !ok do panic("can't parse int")
                vals[id] = val
                id += 1
            }
            sum += vals[0] * vals[1]
        }
    }
    print("Answer part 2:", sum)
}
