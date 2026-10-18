from flask import Blueprint, jsonify
from psycopg.rows import dict_row
from app.database import get_connection

tasks = Blueprint("tasks", __name__)

@tasks.get("/tasks")
def list_tasks():
    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute("SELECT id, title, completed FROM tasks ORDER BY id")
            rows = cur.fetchall()
    return jsonify(rows)

from flask import request

@tasks.post("/tasks")
def create_task():
    data = request.get_json(silent=True)
    if not isinstance(data, dict) or not isinstance(data.get("title"), str) or not data["title"].strip():
        return jsonify({"error": "title is required"}), 400
    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute("INSERT INTO tasks (title) VALUES (%s) RETURNING id, title, completed", (data["title"].strip(),))
            task = cur.fetchone()
    return jsonify(task), 201

@tasks.patch("/tasks/<int:task_id>")
def update_task(task_id):
    data = request.get_json(silent=True)
    if not isinstance(data, dict) or type(data.get("completed")) is not bool:
        return jsonify({"error": "completed must be a boolean"}), 400
    with get_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute("UPDATE tasks SET completed = %s WHERE id = %s RETURNING id, title, completed", (data["completed"], task_id))
            task = cur.fetchone()
    return (jsonify(task), 200) if task else (jsonify({"error": "task not found"}), 404)

@tasks.delete("/tasks/<int:task_id>")
def delete_task(task_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM tasks WHERE id = %s RETURNING id", (task_id,))
            deleted = cur.fetchone()
    return ("", 204) if deleted else (jsonify({"error": "task not found"}), 404)
