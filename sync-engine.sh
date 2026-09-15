#!/usr/bin/env bash
# 엔진 원본은 claude-timecapsule/bin/timecapsule 이다. 형제 폴더에서 복사해 두 프로젝트를 같은 판으로 맞춘다.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-$HERE/../claude-timecapsule/bin/timecapsule}"
[ -f "$SRC" ] || { echo "원본 없음: $SRC"; exit 1; }
cp "$SRC" "$HERE/bin/timecapsule" && chmod +x "$HERE/bin/timecapsule"
cp "$(dirname "$SRC")/../references/format.md" "$HERE/references/format.md"
echo "동기화: $(python3 "$HERE/bin/timecapsule" --version)"
