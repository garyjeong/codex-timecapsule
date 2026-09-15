# codex-timecapsule

Codex CLI 용 로컬 세션 메모리. [claude-timecapsule](../claude-timecapsule) 과 **같은 엔진, 같은 DB**(`~/.timecapsule/index.db`)를 쓴다. Codex 는 MCP 를 거의 쓰지 않으므로 셸 명령과 스킬(SKILL.md), 전역 AGENTS.md 한 절로 붙인다.

- 스킬: `~/.agents/skills/timecapsule` (Codex 가 읽는 경로)
- 지침: `~/.codex/AGENTS.md` 에 「작업 시작 시 `timecapsule recent`, 과거는 `timecapsule search`」 절
- 색인: Claude Code 훅이 두 에이전트 기록을 함께 색인한다. Codex 만 쓰는 날엔 `timecapsule index --quick`
- 원천: `~/.codex/sessions/**/*.jsonl` — `session_meta.cwd` 로 프로젝트를, `response_item` 메시지로 발화를, `function_call` 로 도구 호출을 뽑는다

## 설치

```
./install.sh        # 심링크 + AGENTS.md 절 + doctor
./uninstall.sh
./sync-engine.sh    # claude-timecapsule 의 엔진을 이 폴더로 복사 (판 맞추기)
```

## 구성

```
SKILL.md            Codex 스킬
agents-snippet.md   AGENTS.md 에 붙는 절
bin/timecapsule     엔진 사본 (원본은 claude-timecapsule)
references/format.md
```
