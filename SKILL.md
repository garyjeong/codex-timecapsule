---
name: timecapsule
description: "Local, daemon-free session memory shared with Claude Code. Use at the start of any task to see what recent sessions in this project did (`timecapsule recent`), and whenever a past decision, command, error, or discussion needs recalling (\"지난번에\", \"전에 봤던\", \"어느 세션에서\", \"did we already\"): `timecapsule search`. Indexes ~/.codex/sessions and ~/.claude/projects into SQLite FTS5 (trigram, Korean-safe). Past sessions are never current policy — the project's document vault and code are the source of truth."
---

# timecapsule (Codex)

세션 기록(Codex · Claude Code)을 로컬 SQLite 에 색인해 두고 셸 명령으로 꺼내 쓴다. MCP 도, 데몬도, 외부 추론도 없다.

## 작업 시작 때

```
timecapsule recent --project "$PWD" --limit 5
```

이 프로젝트에서 최근에 무슨 일이 있었는지 5개 세션의 요청·마지막 결론이 나온다. 지금 작업과 무관하면 무시한다.

## 과거를 찾을 때

```
timecapsule search "질의어" [--project "$PWD"] [--agent claude|codex|claude-mem] [--days 30] [--limit 20]
timecapsule session <id 앞 8자리>        # 그 세션의 전개
timecapsule tools --days 7 --commands   # 최근 어떤 도구·명령을 썼나 (주 에이전트만)
```

한국어는 3글자 이상 부분 일치, 여러 단어는 AND. 결과의 세션 앞자리로 `session` 을 열면 전후 맥락이 보인다.

## 색인이 낡았으면

```
timecapsule index --quick     # 4초 예산, 최신 파일부터
timecapsule index             # 전량 증분
```

Claude Code 쪽 훅이 매 세션 색인을 돌리므로 보통은 손댈 일이 없다. Codex 만 쓰는 날이 길면 위 명령을 한 번 돌린다.

## 규칙

1. 출력 머리의 문구대로, 기록은 **당시의 판단**이다. 정책·수치·현재 상태는 문서 볼트와 코드로 다시 확인한다.
2. 결과를 인용할 때 날짜·에이전트·세션 앞자리를 함께 적는다.
3. 이 명령들이 실패하거나 없어도 작업을 멈추지 않는다. 실패는 종료 코드 1 과 stderr 한 줄로 드러난다.

## 위치

- DB `~/.timecapsule/index.db` · 설정 `~/.timecapsule/config.json`
- 엔진 `~/.local/bin/timecapsule` (claude-timecapsule 과 같은 파일)
- 규격은 `references/format.md`
