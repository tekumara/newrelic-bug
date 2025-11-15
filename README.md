# newrelic: Transactions not propagating from middleware repro

This repository reproduces an issue where transactions are not propagating from middleware to route handlers. See [newrelic-python-agent#1581](https://github.com/newrelic/newrelic-python-agent/issues/1581) for details.

To reproduce:

```
uv sync
export NEW_RELIC_LICENSE_KEY=<your-key>
./uvicorn.sh


2025-11-15 12:07:00,018 (6466/MainThread) newrelic.core.agent INFO - New Relic Python Agent (11.1.0)
2025-11-15 12:07:04,079 (6466/NR-Activate-Session/Python Application) newrelic.core.agent_protocol INFO - Reporting to: https://rpm.newrelic.com/....
CanonicalLogMiddleware: transaction_name='main:CanonicalLogMiddleware'
transaction_name=None
```

Last known good versions, where transactions are propagated:

```
uv pip install uvicorn==0.35.0 uvloop==0.21.0
./uvicorn.sh

CanonicalLogMiddleware: transaction_name='main:CanonicalLogMiddleware'
transaction_name='main:ping'
```

All of these version combinations fail to propagate the transaction:

```
uv pip install uvicorn==0.35.0 uvloop==0.22.1

uv pip install uvicorn==0.36.0 uvloop==0.21.0

uv pip install uvicorn==0.38.0 uvloop==0.22.1
```
