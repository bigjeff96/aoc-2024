package day4

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

input_data :: #load("input.txt")

print :: fmt.println

XMAS :: "XMAS"
REV_XMAS :: "SAMX"

MAS :: "MAS"
REV_MAS :: "SAM"

main :: proc() {
    print("Day 4")
    part_1()
    part_2()
}

part_1 :: proc() {
    input := string(input_data)
    rows := parse_input(input)

    count := 0
    for row in rows {
        for i in 0..<len(row)-len(XMAS)+1 {
            slice := row[i:i+len(XMAS)]
            str := string(slice)
            if str == XMAS do count += 1
            if str == REV_XMAS do count += 1
        }
    }

    for i in 0..<len(rows) {
        for j in 0..<len(rows)-len(XMAS)+1 {
            buffer : [4]byte
            for k in 0..<4 {
                buffer[k] = rows[j+k][i]
            }

            str := string(buffer[:])
            if str == XMAS do count += 1
            if str == REV_XMAS do count += 1
        }
    }

    for z in 0..<2*len(rows)-1 {
        buffer := make([dynamic]byte, context.temp_allocator)
        for j := z; j >= 0; j -= 1 {
            i := z - j
            if j < len(rows) && i < len(rows) {
                append(&buffer, rows[i][j])
            }
        }

        for x in 0..<len(buffer)-len(XMAS)+1 {
            slice := buffer[x:x+4]
            str := string(slice[:])
            if str == XMAS do count += 1
            if str == REV_XMAS do count += 1
        }
        free_all(context.temp_allocator)
    }

    for z in 0..<2*len(rows)-1 {
        buffer := make([dynamic]byte, context.temp_allocator)
        for j := z; j >= 0; j -= 1 {
            i := z - j
            if j < len(rows) && i < len(rows) {
                // Mirror
                p := len(rows) - 1 - j
                append(&buffer, rows[i][p])
            }
        }

        for x in 0..<len(buffer)-len(XMAS)+1 {
            slice := buffer[x:x+4]
            str := string(slice[:])
            if str == XMAS do count += 1
            if str == REV_XMAS do count += 1
        }
        free_all(context.temp_allocator)
    }

    print("- Answer part 1:", count)
}

part_2 :: proc() {
    input := string(input_data)
    rows := parse_input(input)
    count := 0

    buffer := make([dynamic]byte)
    for i in 0..<len(rows) - 3 + 1 {
        for j in 0..<len(rows) - 3 + 1 {
            clear(&buffer)
            for k in 0..<3 {
                append(&buffer, rows[i+k][j+k])
            }
            slice := buffer[:]
            str := string(slice)
            if str == MAS || str == REV_MAS {
                clear(&buffer)
                append(&buffer, rows[i+2][j])
                append(&buffer, rows[i+1][j+1])
                append(&buffer, rows[i][j+2])

                slice_2 := buffer[:]
                str_2 := string(slice_2)

                if str_2 == MAS || str_2 == REV_MAS do count += 1
            }
        }
    }

    print("- Answer part 2:", count)
}

parse_input :: proc(input: string) -> [dynamic][dynamic]byte {
    input := input
    rows : [dynamic][dynamic]byte
    id := 0
    for row in strings.split_lines_iterator(&input) {
        row := row
        row_mem := make([dynamic]byte)
        append(&rows, row_mem)
        for element in row {
            append(&rows[id], byte(element))
        }
        id += 1
    }
    return rows
}