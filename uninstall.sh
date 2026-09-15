#!/usr/bin/env bash
# 설치 되돌리기. bin 심링크는 이 폴더를 가리킬 때만 지운다.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="$HOME/.codex/AGENTS.md"
[ -L "$HOME/.agents/skills/timecapsule" ] && rm "$HOME/.agents/skills/timecapsule"
if [ -L "$HOME/.local/bin/timecapsule" ] && [ "$(readlink "$HOME/.local/bin/timecapsule")" = "$HERE/bin/timecapsule" ]; then
  rm "$HOME/.local/bin/timecapsule"
fi
if [ -f "$AGENTS" ] && grep -q '^# timecapsule' "$AGENTS"; then
  python3 - "$AGENTS" <<'EOF'
import sys,re
p=sys.argv[1]; s=open(p).read()
s=re.sub(r"\n?# timecapsule — 세션 메모리\n(?:- .*\n?)+", "", s)
open(p,'w').write(s)
EOF
  echo "AGENTS.md 에서 timecapsule 절 제거"
fi
echo "제거 완료"
