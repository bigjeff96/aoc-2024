package day14

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:os/os2"
import "core:io"

input :: #load("input.txt", string)

print :: fmt.println

main :: proc() {
    print("Day 14")
    part_1()
    part_2()
}

part_1 :: proc() {
    robots := parse_input(input)
    dims := [2]int {101, 103}

    for &robot in robots {
        for _ in 0..<100 {
            robot.pos += robot.velocity
            if robot.pos.x < 0 do robot.pos.x = dims[0] + robot.pos.x
            else if robot.pos.x > dims[0] - 1 do robot.pos.x = robot.pos.x % dims[0]
            if robot.pos.y < 0 do robot.pos.y = dims[1] + robot.pos.y
            else if robot.pos.y > dims[1] - 1 do robot.pos.y = robot.pos.y % dims[1]
        }
    }

    robots_per_quadrant : [4]int

    for robot in robots {
        using robot
        in_quad_1 := pos.x < dims[0] / 2 && pos.y < dims[1]/2
        in_quad_2 := pos.x > dims[0] / 2 && pos.y < dims[1]/2
        in_quad_3 := pos.x < dims[0] / 2 && pos.y > dims[1]/2
        in_quad_4 := pos.x > dims[0] / 2 && pos.y > dims[1]/2

        switch {
        case in_quad_1: robots_per_quadrant[0] += 1
        case in_quad_2: robots_per_quadrant[1] += 1
        case in_quad_3: robots_per_quadrant[2] += 1
        case in_quad_4: robots_per_quadrant[3] += 1
        }
    }
    answer := 1
    for total in robots_per_quadrant do answer *= total


    print("Answer part 1:", answer)
}

part_2 :: proc() {
    robots := parse_input(input)
    dims := [2]int{101, 103}

    total_robots := len(robots)
    answer := 0
    for {
        defer {
            answer += 1
            free_all(context.temp_allocator)
        }
        lookup := make(map[[2]int]struct{}, 5, context.temp_allocator)
        for &robot in robots {
            robot.pos += robot.velocity
            if robot.pos.x < 0 do robot.pos.x = dims[0] + robot.pos.x
            else if robot.pos.x > dims[0] - 1 do robot.pos.x = robot.pos.x % dims[0]
            if robot.pos.y < 0 do robot.pos.y = dims[1] + robot.pos.y
            else if robot.pos.y > dims[1] - 1 do robot.pos.y = robot.pos.y % dims[1]
            lookup[robot.pos] = {}
        }
        if len(lookup) == total_robots do break
    }

    file, _ := os2.create("robot-positions.txt")
    defer os2.close(file)
    for robot in robots {
        os2.write_string(file, fmt.tprintf("%v\t%v\n", robot.pos.x, robot.pos.y))
    }
    print("Answer part 2:", answer)
}

Robot :: struct {
    pos: [2]int,
    velocity: [2]int,
}

parse_input :: proc(input: string) -> (robots: [dynamic]Robot) {
    input := input
    for row in strings.split_lines_iterator(&input) {
        row := row
        strs := strings.split(row, " ")
        robot : Robot
        for i in 0..<2 {
            str := strs[i]
            str_with_values := strings.split(str, ",")
            str_with_values[0] = str_with_values[0][2:]
            values: [2]int
            for j in 0..<2 do values[j] = strconv.atoi(str_with_values[j])

            if i == 0 do robot.pos = values
            else do robot.velocity = values
        }
        append(&robots, robot)
    }
    return
}