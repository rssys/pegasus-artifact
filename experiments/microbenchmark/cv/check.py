import sys

def is_success():
    lines = open(sys.argv[1]).readlines()
    if len(lines) != 2:
        return False
    try:
        float(lines[0].strip())
        float(lines[1].strip())
    except Exception as e:
        return False
    return True

if not is_success():
    exit(1)
