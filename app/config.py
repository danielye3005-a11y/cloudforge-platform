import os


class Config:
    APP_NAME = "CloudForge"
    ENVIRONMENT = os.getenv("APP_ENV", "development")
    DEBUG = ENVIRONMENT == "development"
    TESTING = False


class TestingConfig(Config):
    TESTING = True
    ENVIRONMENT = "testing"
    DEBUG = False


class ProductionConfig(Config):
    ENVIRONMENT = "production"
    DEBUG = False
