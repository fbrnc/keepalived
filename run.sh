#!/bin/bash
set -euo pipefail

pid_file=/run/keepalived.pid

if [[ -f "$pid_file" ]]; then
	pid=$(<"$pid_file")
	if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
		if [[ "$(<"/proc/$pid/comm")" == keepalived ]]; then
			echo "Keepalived is already running with pid $pid." >&2
			exit 1
		fi

		echo "PID file $pid_file points to another process (pid $pid)." >&2
		exit 1
	fi

	echo "Removing stale Keepalived PID file $pid_file."
	rm -f "$pid_file"
fi

echo "Starting Keepalived..."
keepalived --dont-fork --log-console &
keepalived_pid=$!

for _ in {1..50}; do
	if ! kill -0 "$keepalived_pid" 2>/dev/null; then
		wait "$keepalived_pid"
	fi
	if [[ -f "$pid_file" ]]; then
		break
	fi
	sleep 0.1
done

if [[ ! -f "$pid_file" ]]; then
	echo "Keepalived did not create $pid_file." >&2
	kill "$keepalived_pid" 2>/dev/null || true
	wait "$keepalived_pid" 2>/dev/null || true
	exit 1
fi

echo "Starting Keepalived Exporter..."
keepalived_exporter &
exporter_pid=$!

cleanup() {
	trap - EXIT INT TERM
	kill "$keepalived_pid" "$exporter_pid" 2>/dev/null || true
	wait "$keepalived_pid" "$exporter_pid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

wait -n "$keepalived_pid" "$exporter_pid"