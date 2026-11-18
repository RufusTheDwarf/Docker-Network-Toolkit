#!/usr/bin/env bash

set -euo pipefail

docker compose exec -T toolbox bash -lc '
set -euo pipefail

echo "===== DNS ====="
getent hosts web
getent hosts iperf3-server

echo
echo "===== PING ====="
ping -c 3 web

echo
echo "===== HTTP ====="
curl -fsS http://web/

echo
echo "===== NMAP ====="
nmap -sT -p 80 web

echo
echo "===== IPERF3 ====="
iperf3 -c iperf3-server -t 5

echo
echo "Tous les tests ont réussi."
'
