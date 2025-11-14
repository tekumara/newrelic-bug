#! /usr/bin/env sh

# when running locally avoid the need for a license key
if [ ! "$NEW_RELIC_LICENSE_KEY" ]; then
    export NEW_RELIC_DEVELOPER_MODE=true
fi

exec newrelic-admin run-program uvicorn main:app --host 0.0.0.0 --port 8000 --log-level warning
