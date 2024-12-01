run day:
    mkdir -p output
    odin run day{{day}}/ -debug -use-separate-modules -out:output/day{{day}}.exe

run-fast day:
    odin run day{{day}}/ -o:speed -out:output/day{{day}}.exe