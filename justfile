run day:
    @mkdir -p output
    odin run day{{day}}/ -use-separate-modules -o:size -out:output/day{{day}}.exe

run-fast day:
    odin run day{{day}}/ -o:speed -out:output/day{{day}}.exe

run-all:
    #!/usr/bin/env bash
    for dir in `find -name "day*" -type d`; do
        just run "${dir:5}"
    done

