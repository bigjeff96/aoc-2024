package day11

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:math"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 11")
    part_1()
    part_2()
}

has_even_digits :: #force_inline proc(num: int) -> bool {
    total_digits := int(math.log10(f64(num))) + 1
    return total_digits % 2 == 0
}

split_stone :: proc(stone: int) -> (first_half, second_half: int) {
    total_digits := int(math.log10(f64(stone))) + 1
    power_of_ten := int(math.pow(10, f64(total_digits / 2)))
    first_half = stone / power_of_ten
    second_half = stone % power_of_ten
    return
}

part_1 :: proc() {
    data := parse_input(input)
    for i in 0..<25 {
        defer free_all(context.temp_allocator)
        stones_to_split := make([dynamic]int, context.temp_allocator)
        for &stone, id in data {
            switch {
            case stone == 0: stone = 1
            case has_even_digits(stone): append(&stones_to_split, id)
            case: stone *= 2024
            }
        }

        for stone_id in stones_to_split {
            stone := data[stone_id]
            first_half, second_half := split_stone(stone)
            data[stone_id] = first_half
            append(&data, second_half)
        }
    }

    answer := len(data)
    print("Answer part 1:", answer)
}

Args :: struct {
    stone: int,
    steps: int,
}

part_2 :: proc() {
    data := parse_input(input)
    cache := make(map[Args]int)
    num_stones_n_steps :: proc(stone: int, steps: int, cache: ^map[Args]int) -> int {
        if steps == 0 do return 1

        args := Args{stone = stone, steps = steps}
        if args not_in cache {
            result := 0
            switch {
            case stone == 0:
                result = num_stones_n_steps(1, steps - 1, cache)
            case has_even_digits(stone):
                first_half, second_half := split_stone(stone)
                result += num_stones_n_steps(first_half, steps - 1, cache)
                result += num_stones_n_steps(second_half, steps - 1, cache)
            case:
                result = num_stones_n_steps(stone * 2024, steps - 1, cache)
            }
            cache[args] = result
        }

        return cache[args]
    }
    answer := 0
    for stone in data {
    answer += num_stones_n_steps(stone, 75, &cache)
    }
    print("Answer part 2:", answer)
}

parse_input :: proc(input: string) -> [dynamic]int {
    input := input
    data : [dynamic]int
    for row in strings.split_lines_iterator(&input) {
        row := row
        for str_num in strings.split_iterator(&row, " ") {
            append(&data, strconv.atoi(str_num))
        }
    }
    return data
}