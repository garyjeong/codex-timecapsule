#!/usr/bin/env bash
# codex-timecapsule 설치 — 심링크 2개 + 전역 AGENTS.md 한 절. 되돌리기는 uninstall.sh
#   ~/.local/bin/timecapsule          → bin/timecapsule (이미 claude-timecapsule 이 걸어 뒀으면 그대로 둔다)
#   ~/.agents/skills/timecapsule      → 이 폴더 (Codex 가 읽는 스킬 경로)
#   ~/.codex/AGENTS.md                agents-snippet.md 내용을 없으면 덧붙인다
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="$HOME/.codex/AGENTS.md"
command -v python3 >/dev/null || { echo "python3 가 필요하다"; exit 1; }

mkdir -p "$HOME/.local/bin" "$HOME/.agents/skills" "$HOME/.codex" "$HOME/.timecapsule"
chmod +x "$HERE/bin/timecapsule"
if [ ! -e "$HOME/.local/bin/timecapsule" ]; then
  ln -sfn "$HERE/bin/timecapsule" "$HOME/.local/bin/timecapsule"
fi
ln -sfn "$HERE" "$HOME/.agents/skills/timecapsule"

touch "$AGENTS"
if ! grep -q '^# timecapsule' "$AGENTS"; then
  cp "$AGENTS" "$AGENTS.bak-timecapsule-$(date +%Y%m%d-%H%M%S)"
  { echo; cat "$HERE/agents-snippet.md"; } >> "$AGENTS"
  echo "AGENTS.md 에 timecapsule 절 추가"
else
  echo "AGENTS.md 에 이미 timecapsule 절이 있다"
fi

echo "설치 완료"
echo "  bin   : $(readlink "$HOME/.local/bin/timecapsule")"
echo "  skill : $(readlink "$HOME/.agents/skills/timecapsule")"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "  주의  : ~/.local/bin 이 PATH 에 없다";; esac
"$HOME/.local/bin/timecapsule" doctor
