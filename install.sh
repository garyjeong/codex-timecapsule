#!/usr/bin/env bash
# codex-timecapsule 설치 — 심링크 2개 + Codex 훅 2개 + 전역 AGENTS.md 한 절. 되돌리기는 uninstall.sh
#   ~/.local/bin/timecapsule          → bin/timecapsule (이미 claude-timecapsule 이 걸어 뒀으면 그대로 둔다)
#   ~/.agents/skills/timecapsule      → 이 폴더 (Codex 가 읽는 스킬 경로)
#   ~/.codex/hooks.json               SessionStart · UserPromptSubmit · Stop 에 hooks/*.sh 추가 (같은 명령이 있으면 건너뜀)
#   ~/.codex/AGENTS.md                timecapsule 절을 agents-snippet.md 내용으로 바꾸거나 덧붙인다
# 새 훅은 Codex 가 신뢰 승인을 받기 전까지 실행하지 않는다 — 다음 Codex 시작 때 훅 검토에서 승인한다.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="$HOME/.codex/AGENTS.md"
HOOKS="$HOME/.codex/hooks.json"
STAMP="$(date +%Y%m%d-%H%M%S)"
command -v python3 >/dev/null || { echo "python3 가 필요하다"; exit 1; }

mkdir -p "$HOME/.local/bin" "$HOME/.agents/skills" "$HOME/.codex"
chmod +x "$HERE/bin/timecapsule" "$HERE"/hooks/*.sh
if [ ! -e "$HOME/.local/bin/timecapsule" ]; then
  ln -sfn "$HERE/bin/timecapsule" "$HOME/.local/bin/timecapsule"
fi
ln -sfn "$HERE" "$HOME/.agents/skills/timecapsule"

# 훅 등록 — 기존 훅은 그대로 두고 우리 명령만 더한다
[ -f "$HOOKS" ] && cp "$HOOKS" "$HOOKS.bak-timecapsule-$STAMP"
python3 - "$HOOKS" "bash $HERE/hooks/session-start.sh" "bash $HERE/hooks/prompt.sh" "bash $HERE/hooks/stop.sh" <<'PY'
import json, os, sys
path, ss, up, st = sys.argv[1:5]
data = {}
if os.path.exists(path):
    with open(path) as fh:
        data = json.load(fh)
hooks = data.setdefault("hooks", {})
for event, cmd in (("SessionStart", ss), ("UserPromptSubmit", up), ("Stop", st)):
    groups = hooks.setdefault(event, [])
    if any(h.get("command") == cmd for g in groups for h in g.get("hooks", [])):
        continue
    groups.append({"matcher": "", "hooks": [{"type": "command", "command": cmd, "timeout": 15}]})
tmp = path + ".tmp"
with open(tmp, "w") as fh:
    json.dump(data, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
os.replace(tmp, path)
PY

# AGENTS.md 절 — 옛 판이 있으면 새 판으로 바꾼다
touch "$AGENTS"
cp "$AGENTS" "$AGENTS.bak-timecapsule-$STAMP"
python3 - "$AGENTS" "$HERE/agents-snippet.md" <<'PY'
import re, sys
path, snip = sys.argv[1:3]
s = open(path).read()
s = re.sub(r"\n*# timecapsule — 세션 메모리\n(?:- .*\n?)+", "\n", s).rstrip("\n")
s = (s + "\n\n" if s else "") + open(snip).read()
open(path, "w").write(s)
PY
echo "AGENTS.md 의 timecapsule 절 갱신"

echo "설치 완료"
echo "  bin   : $(readlink "$HOME/.local/bin/timecapsule")"
echo "  skill : $(readlink "$HOME/.agents/skills/timecapsule")"
echo "  hooks : $HOOKS — SessionStart · UserPromptSubmit · Stop (다음 Codex 시작 때 훅 신뢰 승인 필요)"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "  주의  : ~/.local/bin 이 PATH 에 없다";; esac
SIB="$HERE/../claude-timecapsule/bin/timecapsule"
if [ -f "$SIB" ] && ! cmp -s "$SIB" "$HERE/bin/timecapsule"; then
  echo "  주의  : 엔진 사본이 claude-timecapsule 원본과 다르다 — ./sync-engine.sh"
fi
"$HOME/.local/bin/timecapsule" doctor
