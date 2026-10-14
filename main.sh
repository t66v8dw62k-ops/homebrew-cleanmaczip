#!/usr/bin/env bash
set -euo pipefail

#---------------------------------------------------------
# Usage
#---------------------------------------------------------

usage() {
	cat <<'EOF'
Usage: cleanmaczip <directory>

Creates <directory>.zip beside the source folder.
Omits AppleDouble / Finder metadata (.DS_Store, ._*, __MACOSX).

Examples:
  cleanmaczip ./solution00
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
	usage
	exit 0
fi

if [[ $# -ne 1 ]]; then
	usage >&2
	exit 1
fi

#---------------------------------------------------------
# Args
#---------------------------------------------------------

if [[ ! -d "$1" ]]; then
	echo "error: not a directory: $1" >&2
	exit 1
fi

SRC="$(cd "$1" && pwd)"
NAME="$(basename "$SRC")"
OUT="$(dirname "$SRC")/${NAME}.zip"

if [[ -e "$OUT" ]]; then
	echo "error: file exists: $OUT" >&2
	exit 1
fi

#---------------------------------------------------------
# Stage
#---------------------------------------------------------

STAGE_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/cleanmaczip.XXXXXX")"
cleanup() { rm -rf "$STAGE_ROOT"; }
trap cleanup EXIT

STAGE="${STAGE_ROOT}/${NAME}"
mkdir -p "$STAGE"

if command -v ditto >/dev/null 2>&1; then
	ditto --norsrc --noextattr --noqtn "$SRC" "$STAGE"
else
	cp -R "$SRC"/. "$STAGE"/
fi

find "$STAGE" -name '.DS_Store' -delete 2>/dev/null || true
find "$STAGE" -name '._*' -delete 2>/dev/null || true
find "$STAGE" -type d -name '__MACOSX' -depth -exec rm -rf {} \; 2>/dev/null || true

#---------------------------------------------------------
# Zip
#---------------------------------------------------------

(
	cd "$STAGE_ROOT"
	COPYFILE_DISABLE=1 zip -r -X -q "$OUT" "$NAME"
)
