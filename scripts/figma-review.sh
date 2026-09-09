#!/usr/bin/env bash
# Public launcher. Supply the private 3615 invitation at the hidden prompt.
set -euo pipefail
umask 077

reviewer_cli() {
    # Keep reviewer state isolated on Linux and macOS without changing HOME.
    "$reviewer_python" -c '
import pathlib, sys
import truffile.storage
root = pathlib.Path(sys.argv.pop(1))
root.mkdir(parents=True, exist_ok=True)
truffile.storage.get_storage_dir = lambda: root
from truffile.cli import main
raise SystemExit(main())
' "$reviewer_root/state" "$@"
}

reviewer_has_connection() {
    "$reviewer_python" - "$reviewer_root/state/state.json" <<'PY'
import json, pathlib, sys
from truffile.remote import RemoteAccess
try:
    state = json.loads(pathlib.Path(sys.argv[1]).read_text())
    assert state.get('last_used_device') == 'truffle-3615'
    assert str(state.get('client_user_id')) == '75709393'
    device = next(d for d in state['devices'] if d['name'] == 'truffle-3615')
    assert device['token']
    RemoteAccess(**device['remote']).validate('truffle-3615')
except (OSError, ValueError, KeyError, TypeError, AssertionError, StopIteration):
    sys.exit(1)
PY
}

reviewer_main() {
    local reviewer_reconnect=false reviewer_system reviewer_candidate reviewer_bootstrap_python=
    case "${1:-}" in
        --help|-h)
            echo 'Usage: bash figma-review.sh [--reconnect]'
            echo 'Requires a Linux/macOS desktop, Python 3.12+, curl, and a private 3615 reviewer invitation.'
            return 0 ;;
        --reconnect) reviewer_reconnect=true; shift ;;
        '') ;;
        *) echo 'Unknown argument. Use --help.' >&2; return 1 ;;
    esac
    if [[ $# -ne 0 ]]; then
        echo 'Unexpected arguments. Use --help.' >&2
        return 1
    fi
    reviewer_system=$(uname -s)
    case "$reviewer_system" in
        Linux)
            if [[ -z ${DISPLAY:-} && -z ${WAYLAND_DISPLAY:-} ]]; then
                echo 'Run this in a desktop terminal on the computer with the browser.' >&2
                return 1
            fi ;;
        Darwin) ;;
        *) echo 'This launcher requires Linux or macOS.' >&2; return 1 ;;
    esac
    if [[ ! -t 0 ]]; then
        echo 'An interactive desktop terminal is required for the invitation and sign-in.' >&2
        return 1
    fi
    command -v curl >/dev/null || { echo 'Install curl, then rerun.' >&2; return 1; }
    for reviewer_candidate in python3.12 python3.13 python3.14 python3; do
        if command -v "$reviewer_candidate" >/dev/null 2>&1 &&
            "$reviewer_candidate" -c 'import sys; sys.exit(0 if sys.version_info >= (3,12) else 1)' 2>/dev/null; then
            reviewer_bootstrap_python="$reviewer_candidate"
            break
        fi
    done
    if [[ -z "$reviewer_bootstrap_python" ]]; then
        echo 'Install Python 3.12 or newer, then rerun this command.' >&2
        return 1
    fi

    reviewer_root="$HOME/.local/share/truffle-figma-review"
    local reviewer_build="$reviewer_root/20260909.1"
    local reviewer_wheel_name='truffile-0.3.24+reviewer.20260909.1-py3-none-any.whl'
    local reviewer_wheel="$reviewer_build/$reviewer_wheel_name"
    mkdir -p "$reviewer_build"
    chmod 700 "$reviewer_root" "$reviewer_build"
    if [[ ! -f "$reviewer_wheel" ]]; then
        echo 'Downloading the Truffle reviewer CLI...'
        curl --fail --show-error --silent --location --proto '=https' --proto-redir '=https' \
            --connect-timeout 20 --max-time 300 \
            "https://raw.githubusercontent.com/deepshard/docs/main/downloads/figma-review/$reviewer_wheel_name" \
            -o "$reviewer_wheel.part"
        mv "$reviewer_wheel.part" "$reviewer_wheel"
    fi
    "$reviewer_bootstrap_python" - "$reviewer_wheel" <<'PY'
import hashlib, pathlib, sys
path = pathlib.Path(sys.argv[1])
expected = '515dd5ccf9d5b7ed0e78e3da7286330ebca1983b6413321a4f9802be2abd9647'
if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
    path.unlink()
    raise SystemExit('Download checksum failed. Rerun the launcher to download it again.')
PY
    if [[ ! -x "$reviewer_build/venv/bin/python" ]]; then
        "$reviewer_bootstrap_python" -m venv "$reviewer_build/venv" || {
            echo 'Could not create the environment. Install the venv package for your Python, then rerun.' >&2
            return 1
        }
    fi
    reviewer_python="$reviewer_build/venv/bin/python"
    if [[ ! -f "$reviewer_build/.installed" ]]; then
        "$reviewer_python" -m pip install "$reviewer_wheel[reviewer]"
        "$reviewer_python" -m playwright install chromium
        touch "$reviewer_build/.installed"
    fi
    if [[ "$reviewer_reconnect" == true ]] || ! reviewer_has_connection; then
        echo 'Paste the private Truffle invitation supplied for this Figma review.'
        reviewer_cli connect --remote
    fi
    if ! reviewer_has_connection; then
        echo 'This launcher needs the invitation for the dedicated reviewer on truffle-3615. Ask the owner for that invitation.' >&2
        return 1
    fi

    local reviewer_catalog
    reviewer_catalog=$(reviewer_cli list apps --json)
    if "$reviewer_python" -c \
        'import json,sys; sys.exit(0 if any(a["name"].casefold() == "figma" for a in json.load(sys.stdin)["apps"]) else 1)' <<< "$reviewer_catalog"; then
        echo 'Using the Figma connection already installed in the review workspace.'
    else
        reviewer_cli install figma
    fi
    echo 'Try: Use Figma to show my account profile.'
    reviewer_cli convo
}

# curl | bash uses stdin for source code. Read prompts and chat from the terminal.
# Keep this call last so bash has parsed the full launcher before interactive work.
if [[ ${1:-} == --help || ${1:-} == -h ]]; then
    reviewer_main "$@"
elif [[ -r /dev/tty ]] && ( : < /dev/tty ) 2>/dev/null; then
    reviewer_main "$@" < /dev/tty
else
    echo 'Run this command in an interactive desktop terminal.' >&2
    exit 1
fi
