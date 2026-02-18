#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

pass() { printf '[PASS] %s\n' "$*"; }
fail() { printf '[FAIL] %s\n' "$*" >&2; exit 1; }

bash -n shdwhack.sh
pass "syntax"

bash shdwhack.sh --help >/tmp/shdw_help.txt
rg --quiet -- '--no-banner' /tmp/shdw_help.txt || fail "help missing --no-banner"
rg --quiet -- '--json' /tmp/shdw_help.txt || fail "help missing --json"
pass "help output"

bash shdwhack.sh --prepare-tools
test -d Tools || fail "Tools was not created"
pass "prepare tools"

bash shdwhack.sh --remove-tools
test ! -d Tools || fail "Tools was not removed"
pass "remove tools"

bash shdwhack.sh --json --prepare-tools >/tmp/shdw_json_out.txt
rg --quiet '"level":"INFO"' /tmp/shdw_json_out.txt || fail "json output missing level"
rg --quiet '"message":"Directory '\''Tools'\'' is ready."' /tmp/shdw_json_out.txt || fail "json output missing expected message"
pass "json output"

set +e
bash shdwhack.sh --prepare-tools --usage >/tmp/shdw_multi_out.txt 2>/tmp/shdw_multi_err.txt
multi_code=$?
set -e
[[ "$multi_code" -eq 64 ]] || fail "multiple action flags should exit 64, got $multi_code"
pass "multiple action flags exit code"

set +e
bash shdwhack.sh --unknown >/tmp/shdw_unknown_out.txt 2>/tmp/shdw_unknown_err.txt
unknown_code=$?
set -e
[[ "$unknown_code" -eq 64 ]] || fail "unknown option should exit 64, got $unknown_code"
pass "unknown option exit code"

bash shdwhack.sh --remove-tools >/dev/null
