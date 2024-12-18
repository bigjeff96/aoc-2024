/* This file was generated by temple on 2024-12-17 21:37:48.627141167 +0000 UTC - DO NOT EDIT! */
/* This file is generated by temple - DO NOT EDIT! */

package temple

import __temple_io "core:io"

compiled_inline :: compiled

/*
Returns the compiled template for the template file at the given path.

Use 'Compiled.with' to render the template into the given (recommended to be buffered) writer with 'this' set to the given T in the template.
Use 'Compiled.approx_bytes' to resize your buffered writer before calling.

**This procedure and file is generated based on your templates, if there is an error here, it most likely originates from your template.**
*/
compiled :: proc($path: string, $T: typeid) -> Compiled(T) {
	when path == "main.odin.temple.twig" {
		return {
			with = proc(__temple_w: __temple_io.Writer, this: T) -> (__temple_n: int, __temple_err: __temple_io.Error) {
				__temple_n += __temple_io.write_string(__temple_w, "package day") or_return /* 1:1 in template */
				__temple_n += __temple_write_escaped_string(__temple_w, this.day) or_return /* 1:12 in template */
				__temple_n += __temple_io.write_string(__temple_w, "\n\nimport \"core:fmt\"\nimport \"core:slice\"\nimport \"core:strings\"\nimport \"core:strconv\"\n\ninput :: #load(\"test_input.txt\", string)\n\nprint :: fmt.println\n\nmain :: proc() {\n    print(\"Day ") or_return /* 1:26 in template */
				__temple_n += __temple_write_escaped_string(__temple_w, this.day) or_return /* 13:16 in template */
				__temple_n += __temple_io.write_string(__temple_w, "\")\n    part_1()\n    part_2()\n}\n\npart_1 :: proc() {\n    parse_input(input)\n    answer := 0\n    print(\"Answer part 1:\", answer)\n}\n\npart_2 :: proc() {\n    answer := 0\n    print(\"Answer part 2:\", answer)\n}\n\nparse_input :: proc(input: string) {\n    input := input\n\n    for row in strings.split_lines_iterator(&input) {\n        row := row\n        for e in row {\n            print(e)\n        }\n    }\n}") or_return /* 13:30 in template */
				return
			}, 
			approx_bytes = 606,
		}
	} else {
		#panic("undefined template \"" + path + "\" did you run the temple transpiler?")
	}
}