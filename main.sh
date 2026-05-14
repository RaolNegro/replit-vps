#!/bin/bash

PORT=${PORT:-8080}
TAILSCALE_AUTH_KEY="${TAILSCALE_AUTH_KEY:-}"

echo "Starting Replit VPS..."

if command -v tailscaled &> /dev/null && [ -n "$TAILSCALE_AUTH_KEY" ]; then
    echo "Starting Tailscale..."
    mkdir -p /tmp/ts
    tailscaled --tun=userspace-networking \
               --state=/tmp/ts/state \
               --socket=/tmp/ts/sock &
    sleep 5
    tailscale --socket=/tmp/ts/sock up --authkey="$TAILSCALE_AUTH_KEY" --hostname=replit-vps
    TS_IP=$(tailscale --socket=/tmp/ts/sock ip -4 2>/dev/null)
    echo "Tailscale IP: $TS_IP"
fi

pip install flask -q

cat > /home/runner/app.py <<PY
import os
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'Replit VPS\nUser: root\nPass: 2010'

@app.route('/ping')
def ping():
    return 'pong'

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
PY

python3 /home/runner/app.py &

echo ""
echo "======================="
echo " REPLIT VPS"
echo "======================="
echo " User  : root"
echo " Pass  : 2010"
echo " URL   : https://replit-vps.${REPL_ID}.repl.co"
echo " Shell : https://replit.com (@replit-vps)"
echo " NOTE  : SSH eksternal TIDAK bisa di Replit"
echo "         Always On: aktfikan di Replit Account > Repls"
echo "         Tailscale: set env TAILSCALE_AUTH_KEY"
echo "======================="

while true; do
    sleep 3600
done
