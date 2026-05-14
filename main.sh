#!/bin/bash

PORT=${PORT:-8080}

pip install flask > /dev/null 2>&1

cat > /home/runner/index.py <<PY
import os
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'Replit VPS Active\nUser: root\nPass: 2010'

@app.route('/ping')
def ping():
    return 'pong'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
PY

python3 /home/runner/index.py &

echo ""
echo "======================="
echo " REPLIT VPS"
echo "======================="
echo " User : root"
echo " Pass : 2010"
echo "======================="

while true; do
    sleep 3600
done
