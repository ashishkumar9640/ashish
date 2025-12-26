from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import uuid

app = Flask(__name__)
CORS(app)

# SQLite for simplicity (replace with PostgreSQL/MySQL later)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///elearning.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# -------------------------------
# DATABASE MODELS
# -------------------------------

class User(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    full_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    role = db.Column(db.String(20), default="student")
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class Course(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    instructor_id = db.Column(db.String(36), db.ForeignKey("user.id"))
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Float, default=0.0)
    level = db.Column(db.String(20))
    is_published = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class Module(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    course_id = db.Column(db.String(36), db.ForeignKey("course.id"))
    title = db.Column(db.String(150))
    module_order = db.Column(db.Integer)


class Lesson(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    module_id = db.Column(db.String(36), db.ForeignKey("module.id"))
    title = db.Column(db.String(150))
    lesson_type = db.Column(db.String(20))
    content = db.Column(db.Text)
    lesson_order = db.Column(db.Integer)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class Enrollment(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("user.id"))
    course_id = db.Column(db.String(36), db.ForeignKey("course.id"))
    enrolled_at = db.Column(db.DateTime, default=datetime.utcnow)


class Payment(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("user.id"))
    course_id = db.Column(db.String(36), db.ForeignKey("course.id"))
    amount = db.Column(db.Float)
    payment_status = db.Column(db.String(20))
    payment_provider = db.Column(db.String(50))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class Certificate(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("user.id"))
    course_id = db.Column(db.String(36), db.ForeignKey("course.id"))
    issued_at = db.Column(db.DateTime, default=datetime.utcnow)

# -------------------------------
# CREATE TABLES
# -------------------------------
with app.app_context():
    db.create_all()

# -------------------------------
# API: CREATE COURSE (from HTML)
# -------------------------------
@app.route("/courses", methods=["POST"])
def create_course():
    data = request.json

    # Instructor
    instructor = User(
        full_name=data["instructor"]["full_name"],
        email=data["instructor"]["email"],
        role="instructor"
    )
    db.session.add(instructor)
    db.session.commit()

    # Course
    course = Course(
        instructor_id=instructor.id,
        title=data["title"],
        description=data.get("description"),
        price=data.get("price"),
        level=data.get("level"),
        is_published=True
    )
    db.session.add(course)
    db.session.commit()

    # Modules & Lessons
    for m in data.get("modules", []):
        module = Module(
            course_id=course.id,
            title=m["title"],
            module_order=m["module_order"]
        )
        db.session.add(module)
        db.session.commit()

        for l in m.get("lessons", []):
            lesson = Lesson(
                module_id=module.id,
                title=l["title"],
                lesson_type=l["lesson_type"],
                content=l.get("content"),
                lesson_order=l["lesson_order"]
            )
            db.session.add(lesson)

    db.session.commit()

    return jsonify({
        "message": "Course saved in SQL database",
        "course_id": course.id
    }), 201

# -------------------------------
# API: GET COURSES
# -------------------------------
@app.route("/courses", methods=["GET"])
def get_courses():
    courses = Course.query.all()
    return jsonify([
        {
            "id": c.id,
            "title": c.title,
            "price": c.price,
            "level": c.level
        } for c in courses
    ])

# -------------------------------
# RUN SERVER
# -------------------------------
if __name__ == "__main__":
    app.run(debug=True)
