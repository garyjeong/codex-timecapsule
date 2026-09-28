#!/usr/bin/env bash
# 설치 되돌리기. bin 심링크는 이 폴더를 가리킬 때만 지우고, hooks.json 에서는 이 폴더의 훅만 뺀다.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="$HOME/.codex/AGENTS.md"
HOOKS="$HOME/.codex/hooks.json"
[ -L "$HOME/.agents/skills/timecapsule" ] && rm "$HOME/.agents/skills/timecapsule"
if [ -L "$HOME/.local/bin/timecapsule" ] && [ "$(readlink "$HOME/.local/bin/timecapsule")" = "$HERE/bin/timecapsule" ]; then
  rm "$HOME/.local/bin/timecapsule"
fi
if [ -f "$HOOKS" ] && grep -q "$HERE/hooks/" "$HOOKS"; then
  python3 - "$HOOKS" "$HERE/hooks/" <<'PY'
import json, sys
path, mine = sys.argv[1:3]
data = json.load(open(path))
for event, groups in list(data.get("hooks", {}).items()):
    for g in groups:
        g["hooks"] = [h for h in g.get("hooks", []) if mine not in h.get("command", "")]
    data["hooks"][event] = [g for g in groups if g.get("hooks")]
    if not data["hooks"][event]:
        del data["hooks"][event]
json.dump(data, open(path, "w"), ensure_ascii=False, indent=2)
PY
  echo "hooks.json 에서 timecapsule 훅 제거"
fi
if [ -f "$AGENTS" ] && grep -q '^# timecapsule' "$AGENTS"; then
  python3 - "$AGENTS" <<'PY'
import sys,re
p=sys.argv[1]; s=open(p).read()
s=re.sub(r"\n?# timecapsule — 세션 메모리\n(?:- .*\n?)+", "", s)
open(p,'w').write(s)
PY
  echo "AGENTS.md 에서 timecapsule 절 제거"
fi
echo "제거 완료"
