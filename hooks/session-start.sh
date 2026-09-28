#!/usr/bin/env bash
# Codex SessionStart 훅 — 대화형 세션에만 이 프로젝트의 최근 세션 요약을 넣는다(일반 텍스트 출력은 Codex 가 모델 문맥으로 붙인다).
# codex exec·검토·가디언 세션은 엔진이 가려 아무것도 내지 않는다. 어떤 경우에도 세션을 막지 않는다(exit 0).
TC="${TIMECAPSULE_BIN:-$(command -v timecapsule 2>/dev/null)}"
[ -x "$TC" ] || TC="$HOME/.local/bin/timecapsule"
[ -x "$TC" ] || exit 0
"$TC" hook codex-session-start 2>/dev/null || true
exit 0
