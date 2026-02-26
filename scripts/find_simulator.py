#!/usr/bin/env python3
"""Find the first available iPhone simulator UDID from simctl JSON output."""
import json, sys

data = json.load(sys.stdin)
for runtime, devices in data["devices"].items():
    for d in devices:
        if "iPhone" in d["name"] and d["isAvailable"]:
            print(d["udid"])
            sys.exit(0)

sys.exit(1)
