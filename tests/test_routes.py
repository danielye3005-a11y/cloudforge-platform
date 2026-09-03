import pytest

from app import create_app


from app.config import TestingConfig


@pytest.fixture
def client():
    app = create_app(TestingConfig)
    

    with app.test_client() as client:
        yield client


def test_index(client):
    response = client.get("/")

    assert response.status_code == 200
    assert response.json["project"] == "CloudForge"
    assert response.json["service"] == "cloudforge-api"
    assert response.json["status"] == "running"


def test_health(client):
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json == {"status": "healthy"}


def test_version(client):
    response = client.get("/version")

    assert response.status_code == 200
    assert response.json["service"] == "cloudforge-api"
    assert response.json["version"] == "0.1.0"

def test_ready(client):
    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json == {"status": "ready"}


def test_not_found(client):
    response = client.get("/does-not-exist")

    assert response.status_code == 404
    assert response.json["error"] == "not_found"
