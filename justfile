run day:
    @mkdir -p output
    odin run day{{day}}/ -use-separate-modules -debug -out:output/day{{day}}.exe

run-fast day:
    odin run day{{day}}/ -o:speed -out:output/day{{day}}.exe

run-all:
    #!/usr/bin/env bash
    for dir in `fd ^day.*$ -t d | rg "\d+" -o | sort -n`; do
        just run $dir
    done

run-fast-all:
    #!/usr/bin/env bash
    for dir in `fd ^day.*$ -t d | rg "\d+" -o | sort -n`; do
        just run-fast $dir
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

make-next-day:
    #!/usr/bin/env bash
    count=$(fd ^day.*$ -t d | wc -l)
    ((count=count+1))
    just make-day $count

day-14:
    just build 14
    output/day14.exe
    python3 tools/plot-script.py
    rm robot-positions.txt
