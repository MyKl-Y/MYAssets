# server/app/__init__.py

'''
App Factory
'''

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_migrate import Migrate

db = SQLAlchemy()
jwt = JWTManager()
migrate = Migrate()

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')

    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    CORS(app)
    migrate.init_app(app, db)

    # Register blueprints
    from .routes import bp as main_bp
    app.register_blueprint(main_bp, url_prefix='/api/v1')

    with app.app_context():
        db.create_all()

    return app