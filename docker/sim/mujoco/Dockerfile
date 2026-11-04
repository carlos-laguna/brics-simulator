FROM astral/uv:python3.12-bookworm-slim

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-install-project --group sim

COPY . /app/

RUN uv sync --frozen --group sim
RUN uv run python -c "import brics; import mujoco; print('Imports verified successfully!')"