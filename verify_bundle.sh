#!/usr/bin/env bash
# Source-free integrity check: re-hash content-addressed objects and recompute the bundle root.
set -uo pipefail
cd "$(dirname "$0")"
command -v python3 >/dev/null 2>&1 || { echo "need python3"; exit 2; }
python3 - <<'PY'
import json, hashlib, os, sys
m = json.load(open("store/MANIFEST.json")); pinned = open("store/BUNDLE_ROOT").read().strip()
lines, fail = [], False
for a in m["artifacts"]:
    obj = os.path.join("store","objects",a["sha256"])
    if not os.path.exists(obj): print("  [FAIL] missing", a["path"]); fail=True; continue
    h = hashlib.sha256(open(obj,"rb").read()).hexdigest()
    if h != a["sha256"]: print("  [FAIL] corrupt", a["path"]); fail=True; continue
    lines.append(f'{a["sha256"]}  {a["path"]}')
lines.sort()
root = hashlib.sha256(("\n".join(lines)+"\n").encode()).hexdigest()
print(("  [PASS] bundle_root reproduces: "+root) if (root==pinned and not fail) else ("  [FAIL] "+root+" != "+pinned))
sys.exit(0 if (root==pinned and not fail) else 1)
PY