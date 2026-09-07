import os
from decimal import Decimal

import pytest
from pydantic import ValidationError

from app.main import BoatIn, CatchIn, TripIn


def test_boat_capacity_must_be_positive():
    with pytest.raises(ValidationError):
        BoatIn(name="X", registration_no="X-1", capacity_kg=-1)


def test_catch_weight_must_be_positive():
    with pytest.raises(ValidationError):
        CatchIn(trip_id=1, fish_type_id=1, cans=2, weight_kg=Decimal("0"))


def test_trip_returns_after_departure():
    with pytest.raises(ValidationError):
        TripIn(boat_id=1, crew_id=1, departure_date="2026-09-10", return_date="2026-09-09")


# Optional DB-backed smoke test. To enable, set TEST_DATABASE_URL.
if os.getenv("TEST_DATABASE_URL"):
    from fastapi.testclient import TestClient
    from app.main import app

    client = TestClient(app)

    def test_health_with_database():
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json()["status"] == "ok"
