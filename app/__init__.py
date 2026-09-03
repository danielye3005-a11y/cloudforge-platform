from flask import Flask

from app.routes import main


def create_app():
    app = Flask(__name__)

    app.register_blueprint(main)

    return app


import logging

from flask import Flask, jsonify

from app.config import Config
from app.routes import main


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
    )

    app.logger.info(
        "Starting %s in %s environment",
        app.config["APP_NAME"],
        app.config["ENVIRONMENT"],
    )

    app.register_blueprint(main)

    @app.errorhandler(404)
    def not_found(error):
        return jsonify(
            {
                "error": "not_found",
                "message": "The requested resource was not found",
            }
        ), 404

    @app.errorhandler(500)
    def internal_error(error):
        app.logger.exception("Unhandled server error")

        return jsonify(
            {
                "error": "internal_server_error",
                "message": "An unexpected error occurred",
            }
        ), 500

    return app
