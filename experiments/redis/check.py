import sys
import json

data = json.loads(open(sys.argv[1]).read())
if data["ALL STATS"]["Totals"]["Ops/sec"] != 0.0:
    sys.exit(0)
else:
    sys.exit(1)

