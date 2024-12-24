run day:
    @mkdir -p output
    odin run day{{day}}/ -use-separate-modules -debug -out:output/day{{day}}.exe

run-fast day:
    odin run day{{day}}/ -o:speed -out:output/day{{day}}.exe

run-all:
    #!/usr/bin/env bash
    for dir in `find -name "day*" -type d`; do
        just run "${dir:5}"
    done

build day:
    odin build day{{day}}/ -use-separate-modules -debug -out:output/day{{day}}.exe

build-fast day:
    odin build day{{day}}/ -o:speed -out:output/day{{day}}.exe

build-tool:
	odin build tools/temple/cli/ -out:tools/temple_cli.exe
	./tools/temple_cli.exe tools/make_day_dir/ tools/temple/
	odin build tools/make_day_dir/ -out:tools/make_day_dir.exe

make-day day:
	tools/make_day_dir.exe {{day}}
	python3 tools/get_input.py {{day}} > day{{day}}/input.txt

watch day:
    watchexec -w day{{day}}/ just run {{day}}