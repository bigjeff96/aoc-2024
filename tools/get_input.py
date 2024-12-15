import sys
sys.path.append('/home/joe/.local/pipx/venvs/advent-of-code-data/lib/python3.11/site-packages')
from aocd import get_data

print(get_data(day=int(sys.argv[1]), year=2024))