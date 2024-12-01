package day1

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

input_data :: #load("input.txt")

print :: fmt.println

main :: proc() {
    print("Day 1")
    part_1()
    part_2()
}

part_2 :: proc() {
    data := string(input_data)
    array_1 : [dynamic]int
    array_2 : [dynamic]int

    id := 0
    for element in strings.fields_iterator(&data) {
        thing, ok := strconv.parse_int(element, 10)
        if !ok do panic("can't parse int")
        if id % 2 == 0 do append(&array_1, thing)
        if id % 2 == 1 do append(&array_2, thing)
        id += 1
    }

    slice.sort(array_1[:])
    slice.sort(array_2[:])

    sum := 0
    for id in 0..<len(array_1) {
        val := array_1[id]
        count := 0
        for id_t in 0..<len(array_2) {
            val_t := array_2[id_t]
            if val_t == val do count += 1
        }

        sum += val * count
    }

    print("- Answer part 2:", sum)
}

part_1 :: proc() {
    data := string(input_data)
    array_1 : [dynamic]int
    array_2 : [dynamic]int

    id := 0
    for element in strings.fields_iterator(&data) {
        thing, ok := strconv.parse_int(element, 10)
        if !ok do panic("can't parse int")
        if id % 2 == 0 do append(&array_1, thing)
        if id % 2 == 1 do append(&array_2, thing)
        id += 1
    }

    slice.sort(array_1[:])
    slice.sort(array_2[:])

    sum := 0
    for id in 0..<len(array_1) {
        sum += abs(array_1[id] - array_2[id])
    }
    fmt.println("- Answer part 1:", sum)
}
