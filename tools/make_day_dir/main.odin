package make_day_dir

import "core:fmt"
import "../temple"
import "core:os/os2"

Day :: struct {
    day: string
}

print :: fmt.println
main_for_day := temple.compiled("main.odin.temple.twig", Day)

main :: proc() {

    day := Day{os2.args[1]}
    day_dir := fmt.tprintf("day%v",day.day)
    err := os2.mkdir(day_dir)
    if err == .Exist {
        fmt.panicf("Remove day%v folder", day.day)
    }

    main_file_str := fmt.tprintf("%v/main.odin", day_dir)
    input_file_str := fmt.tprintf("%v/input.txt", day_dir)
    test_input_file_str := fmt.tprintf("%v/test_input.txt", day_dir)

    main_file, err_1 := os2.create(main_file_str)
    input_file, err_2 := os2.create(input_file_str)
    test_input_file, err_3 := os2.create(test_input_file_str)

    if err_1 != nil do fmt.panicf("%v", err_1)
    if err_2 != nil do fmt.panicf("%v", err_2)
    if err_3 != nil do fmt.panicf("%v", err_3)

    main_for_day.with(main_file.stream, day)
}
