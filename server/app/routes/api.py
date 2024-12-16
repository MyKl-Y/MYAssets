# server/app/api.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, create_access_token
from flask_login import login_required, current_user
from ..models import db, User, Transaction, Budget
from ..utils import generate_token
from werkzeug.security import check_password_hash
from . import bp

# User Registration
@bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if User.query.filter_by(username=data['username']).first():
        return jsonify({"message": "Username already exists"}), 400
    new_user = User(username=data['username'], email=data['email'])
    new_user.set_password(data['password'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully"}), 201

# User Login (JWT)
@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        token = generate_token(identity=user.id)
        return jsonify({"access_token": token, "user_id": user.id}), 200
    return jsonify({"message": "Invalid username or password"}), 401

# Get Current User
@bp.route('/user', methods=['GET'])
@jwt_required()
def get_current_user():
    user_id = current_user.id
    user = User.query.get(user_id)
    return jsonify(user.to_dict())

# Add Transaction
@bp.route('/transactions', methods=['POST'])
@jwt_required()
def add_transaction():
    data = request.get_json()
    new_transaction = Transaction(**data)
    db.session.add(new_transaction)
    db.session.commit()
    return jsonify(new_transaction.to_dict()), 201

# Get Transactions
@bp.route('/transactions', methods=['GET'])
@jwt_required()
def get_transactions():
    user_id = current_user.id
    transactions = Transaction.query.filter_by(user_id=user_id).all()
    return jsonify([t.to_dict() for t in transactions])