# server/app/api.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, create_access_token, get_jwt_identity
from ..models import db, User, Transaction, Budget, Account
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
        token = generate_token(identity=str(user.id))
        return jsonify({"access_token": token, "user_id": user.id}), 200
    return jsonify({"message": "Invalid username or password"}), 401

# Get Current User
@bp.route('/user', methods=['GET'])
@jwt_required()
def get_current_user():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    return jsonify(user.to_dict())

# Add Transaction
@bp.route('/transactions', methods=['POST'])
@jwt_required()
def add_transaction():
    user_id = get_jwt_identity()
    data = request.get_json()

    amount = data['amount']
    description = data['description']
    category = data['category']
    account = data['account']
    type = data['type']
    timestamp = data['timestamp']

    new_transaction = Transaction(
        user_id = user_id,
        amount = amount,
        description = description,
        category = category,
        account = account,
        type = type,
        timestamp = timestamp
    )

    db.session.add(new_transaction)

    account_to_change = Account.query.filter_by(name=account, user_id=user_id).first()

    if type == 'income':
        account_to_change.balance += float(amount)
    elif type == 'expense':
        account_to_change.balance -= float(amount)

    db.session.commit()

    return jsonify(new_transaction.to_dict()), 201

# Get Transactions
@bp.route('/transactions', methods=['GET'])
@jwt_required()
def get_transactions():
    user_id = get_jwt_identity()
    transactions = Transaction.query.filter_by(user_id=user_id).all()
    return jsonify([t.to_dict() for t in transactions])

# Add Account
@bp.route('/accounts', methods=['POST'])
@jwt_required()
def add_account():
    user_id = get_jwt_identity()
    data = request.get_json()

    name = data['name']
    description = data['description']
    type = data['type']
    balance = data['balance']

    existing_account = Account.query.filter_by(user_id=user_id, name=name).first()

    if existing_account:
        return jsonify({'message': 'Account with name already exists'}), 400
    
    new_account = Account(
        user_id = user_id,
        name = name,
        description = description,
        type = type,
        balance = balance
    )

    db.session.add(new_account)
    db.session.commit()

    return jsonify(new_account.to_dict()), 201

# Get Accounts
@bp.route('/accounts', methods=['GET'])
@jwt_required()
def get_accounts():
    user_id = get_jwt_identity()
    accounts = Account.query.filter_by(user_id=user_id).all()
    return jsonify([a.to_dict() for a in accounts])