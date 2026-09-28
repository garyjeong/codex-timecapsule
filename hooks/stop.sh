#!/usr/bin/env bash
# Codex Stop 훅 — 방금 끝난 턴까지 색인한다. 출력 없음(Stop 훅의 비JSON 출력은 실패로 처리된다), 항상 exit 0.
TC="${TIMECAPSULE_BIN:-$(command -v timecapsule 2>/dev/null)}"
[ -x "$TC" ] || TC="$HOME/.local/bin/timecapsule"
[ -x "$TC" ] || exit 0
"$TC" hook codex-stop >/dev/null 2>&1 || true
exit 0
