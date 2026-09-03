from flask import Blueprint, jsonify

main = Blueprint("main", __name__)


@main.route("/")
def index():
    return jsonify(
        {
            "project": "CloudForge",
            "service": "cloudforge-api",
            "status": "running",
        }
    )


@main.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200


@main.route("/ready")
def ready():
    return jsonify({"status": "ready"}), 200

@main.route("/version")
def version():
    return jsonify(
        {
            "service": "cloudforge-api",
            "version": "0.1.0",
        }
    ), 200
