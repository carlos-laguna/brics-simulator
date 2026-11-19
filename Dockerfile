# syntax=docker/dockerfile:1
# Before a recorded research baseline, replace this tag with its tested digest.
FROM astral/uv:python3.12-bookworm-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=never
ENV PATH="/app/.venv/bin:$PATH"

# Cache dependency installation separately from changes to BRICS source files.
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-install-project --group dev

COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --group dev

# This is a one-off environment check, not a simulation server.
CMD ["python", "-c", "import brics; print(brics.__file__)"]
