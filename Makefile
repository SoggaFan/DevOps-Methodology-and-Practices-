.PHONY: setup run test quality migrate backup restore verify up down container-check

setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

run:
	uvicorn app.main:app --reload

test:
	PYTHONPATH=. pytest -q

quality:
	python -m compileall app tests

migrate:
	cat sql/001_schema.sql sql/002_seed.sql | docker compose exec -T db psql -U $${POSTGRES_USER:-fishing} -d $${POSTGRES_DB:-fishing}

backup:
	docker compose exec -T db pg_dump -U $${POSTGRES_USER:-fishing} -d $${POSTGRES_DB:-fishing} > backup.sql

restore:
	cat backup.sql | docker compose exec -T db psql -U $${POSTGRES_USER:-fishing} -d $${POSTGRES_DB:-fishing}

verify: quality test

up:
	docker compose up --build -d

down:
	docker compose down

container-check:
	docker compose ps && curl -fsS http://localhost:8000/health
