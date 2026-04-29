#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <env-dir-name> <server.py> <requirements.txt> [<requirements.txt> ...]" >&2
  exit 64
fi

env_dir_name="$1"
shift
server_path="$1"
shift
requirements_files=("$@")

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_dir="$(cd "$script_dir/../.." && pwd)"

if [[ ! "$server_path" = /* ]]; then
  server_path="$workspace_dir/$server_path"
fi

for idx in "${!requirements_files[@]}"; do
  requirement_path="${requirements_files[$idx]}"
  if [[ ! "$requirement_path" = /* ]]; then
    requirements_files[$idx]="$workspace_dir/$requirement_path"
  fi
done

system_python="${PYTHON_BIN:-}"
if [[ -z "$system_python" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    system_python="$(command -v python3)"
  elif command -v python >/dev/null 2>&1; then
    system_python="$(command -v python)"
  else
    echo "[rethlas-mcp] python3 is required to start $server_path" >&2
    exit 1
  fi
fi

env_dir="$workspace_dir/.vscode/$env_dir_name"
venv_python="$env_dir/bin/python"
stamp_file="$env_dir/.requirements.sha256"

if [[ ! -x "$venv_python" ]]; then
  echo "[rethlas-mcp] creating $env_dir_name" >&2
  "$system_python" -m venv "$env_dir"
  "$venv_python" -m pip install --upgrade --disable-pip-version-check pip >/dev/null 2>&1
fi

requirements_hash="$($system_python - "${requirements_files[@]}" <<'PY'
import hashlib
import pathlib
import sys

hash_value = hashlib.sha256()
for raw_path in sys.argv[1:]:
    path = pathlib.Path(raw_path)
    hash_value.update(path.read_bytes())
    hash_value.update(b"\0")
print(hash_value.hexdigest())
PY
)"

if [[ ! -f "$stamp_file" ]] || [[ "$(cat "$stamp_file")" != "$requirements_hash" ]]; then
  echo "[rethlas-mcp] installing dependencies for $env_dir_name" >&2
  pip_args=()
  for requirement_path in "${requirements_files[@]}"; do
    pip_args+=(-r "$requirement_path")
  done
  "$venv_python" -m pip install --disable-pip-version-check "${pip_args[@]}" 1>&2
  printf '%s' "$requirements_hash" > "$stamp_file"
fi

export PYTHONUNBUFFERED=1
exec "$venv_python" "$server_path"