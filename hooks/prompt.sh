#!/usr/bin/env bash
# Codex UserPromptSubmit 훅 — 그 프롬프트와 닿는 과거 세션을 넣는다. exec·서브에이전트 세션이면 엔진이 건너뛴다. 실패해도 세션을 막지 않는다.
TC="${TIMECAPSULE_BIN:-$(command -v timecapsule 2>/dev/null)}"
[ -x "$TC" ] || TC="$HOME/.local/bin/timecapsule"
[ -x "$TC" ] || exit 0
"$TC" hook codex-prompt 2>/dev/null || true
exit 0
