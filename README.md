# codex-timecapsule

Codex CLI 용 로컬 세션 메모리. [claude-timecapsule](../claude-timecapsule) 과 **같은 엔진, 같은 DB**(`~/.timecapsule/index.db`)를 쓴다. Codex 훅(SessionStart·UserPromptSubmit·Stop)과 스킬(SKILL.md), 전역 AGENTS.md 한 절로 붙인다.

- 훅: `~/.codex/hooks.json` — SessionStart 는 빠른 색인 후 이 프로젝트의 최근 대화형 세션 요약을 문맥에 넣고, UserPromptSubmit 은 그 프롬프트와 닿는 과거 세션 3개(≤1.2k자)를 넣고(0.3), Stop 은 매 턴 끝에 색인한다. 새 훅은 다음 Codex 시작 때 신뢰 승인을 받아야 돈다. `codex exec`·서브에이전트 세션에서는 아무것도 하지 않는다(트랜스크립트 `session_meta` 또는 조상 프로세스 `codex exec` 로 판별)
- 신뢰: Codex 는 새 훅을 승인 전까지 실행하지 않는다. 설치 뒤 첫 Codex 시작 때 훅 검토에서 승인해야 동작한다
- 스킬: `~/.agents/skills/timecapsule` (Codex 가 읽는 경로)
- 지침: `~/.codex/AGENTS.md` 에 「훅 요약이 없으면 `timecapsule recent`, 과거는 `timecapsule search`」 절
- 원천: `~/.codex/sessions/**/*.jsonl` — `session_meta` 로 프로젝트·세션 종류를, `response_item` 메시지로 발화를(주입 블록 제거), `function_call` 로 도구 호출을 뽑는다

## 설치

```
./install.sh        # 심링크 + hooks.json 병합 + AGENTS.md 절 갱신 + doctor (기존 파일은 .bak-timecapsule-* 로 백업)
./uninstall.sh      # 이 폴더의 훅·절·심링크만 뺀다
./sync-engine.sh    # claude-timecapsule 의 엔진·규격을 이 폴더로 복사 (판 맞추기)
```

## 구성

```
SKILL.md            Codex 스킬
agents-snippet.md   AGENTS.md 에 붙는 절
hooks/session-start.sh · hooks/stop.sh   Codex 훅 (엔진의 `timecapsule hook codex-*` 를 부른다)
bin/timecapsule     엔진 사본 (원본·시험은 claude-timecapsule)
references/format.md
```
