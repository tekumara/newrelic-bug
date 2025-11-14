#! /usr/bin/env sh

# when running locally avoid the need for a license key
if [ ! "$NEW_RELIC_LICENSE_KEY" ]; then
    export NEW_RELIC_DEVELOPER_MODE=true
fi

# Start curl loop in background
(
    while true; do
        curl -sS http://127.0.0.1:8000/ping > /dev/null 2>&1
        sleep 1
    done
) &
CURL_PID=$!

# Cleanup function to kill curl loop on SIGINT
cleanup() {
    kill $CURL_PID 2>/dev/null
    exit
}

# Trap SIGINT and SIGTERM
trap cleanup INT TERM

export NEW_RELIC_CONFIG_FILE=newrelic.ini
export NEW_RELIC_STARTUP_DEBUG=true
# Run uvicorn (without exec so trap remains active)
newrelic-admin run-program uvicorn main:app --host 0.0.0.0 --port 8000 --log-level warning

# Cleanup on exit
cleanup
