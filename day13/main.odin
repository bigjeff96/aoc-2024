package day13

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import la "core:math/linalg"
import "core:math"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 13")
    part_1()
    part_2()
}

Claw :: struct {
    button_a: [2]int,
    button_b: [2]int,
    prize: [2]int,
}

part_1 :: proc() {
    claws := parse_input(input)
    answer : f64 = 0
    outer: for claw in claws {
        eq_matrix : matrix[2,2]f64
        eq_matrix[0,0] = auto_cast claw.button_a[0]
        eq_matrix[0,1] = auto_cast claw.button_b[0]
        eq_matrix[1,0] = auto_cast claw.button_a[1]
        eq_matrix[1,1] = auto_cast claw.button_b[1]

        det := la.determinant(eq_matrix)
        if det == 0 do continue
        casted_prize : [2]f64
        for i in 0..<2 do casted_prize[i] = auto_cast claw.prize[i]

        inv_matrix := la.inverse(eq_matrix)
        solution := inv_matrix * casted_prize

        for i in 0..<2 do solution[i] = math.round(solution[i])
        prize_after_rounding := eq_matrix * solution

        for i in 0..<2 {
            if f64(claw.prize[i]) != prize_after_rounding[i] do continue outer
        }
        answer += 3 * solution[0] + solution[1]
    }
    print("Answer part 1:", answer)
}

part_2 :: proc() {
    claws := parse_input(input)
    answer : f64 = 0
    outer: for &claw, id in claws {
        claw.prize += { 10000000000000, 10000000000000}
        eq_matrix : matrix[2,2]f64
        eq_matrix[0,0] = auto_cast claw.button_a[0]
        eq_matrix[0,1] = auto_cast claw.button_b[0]
        eq_matrix[1,0] = auto_cast claw.button_a[1]
        eq_matrix[1,1] = auto_cast claw.button_b[1]

        det := la.determinant(eq_matrix)
        if det == 0 do continue
        casted_prize : [2]f64
        for i in 0..<2 do casted_prize[i] = auto_cast claw.prize[i]

        inv_matrix := la.inverse(eq_matrix)
        solution := inv_matrix * casted_prize

        for i in 0..<2 do solution[i] = math.round(solution[i])
        prize_after_rounding := eq_matrix * solution

        for i in 0..<2 {
            if f64(claw.prize[i]) != prize_after_rounding[i] do continue outer
        }

        answer += 3 * solution[0] + solution[1]
    }
    print("Answer part 2:", int(answer))
}

parse_input :: proc(input: string) -> (claws: [dynamic]Claw) {
    input := input
    for row in strings.split_lines_iterator(&input) {
        row := row

        if strings.contains(row, "Button A:") {
            append(&claws, Claw{})
            latest_claw := slice.last_ptr(claws[:])
            strs := strings.split(row, ", ")
            for i in 0..<2 {
                index := strings.index(strs[i], "+")
                str_val := strs[i][index+1:]
                val := strconv.atoi(str_val)
                latest_claw.button_a[i] = val
            }
        } else if strings.contains(row, "Button B:") {
            latest_claw := slice.last_ptr(claws[:])
            strs := strings.split(row, ", ")
            for i in 0..<2 {
                index := strings.index(strs[i], "+")
                str_val := strs[i][index+1:]
                val := strconv.atoi(str_val)
                latest_claw.button_b[i] = val
            }
        } else if strings.contains(row, "Prize:") {
            latest_claw := slice.last_ptr(claws[:])
            strs := strings.split(row, ", ")
            for i in 0..<2 {
                index := strings.index(strs[i], "=")
                str_val := strs[i][index+1:]
                val := strconv.atoi(str_val)
                latest_claw.prize[i] = val
            }
        }
    }
    return
}