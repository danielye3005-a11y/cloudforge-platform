import os
import psycopg


def get_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST", "postgres.cloudforge-db.svc.cluster.local"),
        port=int(os.getenv("DB_PORT", "5432")),
        dbname=os.getenv("DB_NAME", "cloudforge"),
        user=os.getenv("DB_USER", "cloudforge"),
        password=os.environ["DB_PASSWORD"],
        connect_timeout=5,
    )
