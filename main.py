from collections.abc import Awaitable, Callable

import newrelic.agent
from fastapi import FastAPI, Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response

app = FastAPI()

class CanonicalLogMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable[[Request], Awaitable[Response]]) -> Response:
        transaction = newrelic.agent.current_transaction()
        transaction_name = transaction.name if transaction else None
        print(f"CanonicalLogMiddleware: {transaction_name=}")
        return await call_next(request)

app.add_middleware(
    CanonicalLogMiddleware,
)

async def load_newrelic_agent_instance() -> None:
    newrelic.agent.register_application(timeout=5.0)

# load newrelic agent on startup rather than first request
app.add_event_handler("startup", load_newrelic_agent_instance)


@newrelic.agent.web_transaction()
@app.get("/ping")
async def ping() -> str:
    transaction = newrelic.agent.current_transaction()
    transaction_name = transaction.name if transaction else None
    print(f"{transaction_name=}")
    return "pong"

