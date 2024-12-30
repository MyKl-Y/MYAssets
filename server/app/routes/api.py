# server/app/api.py
from datetime import datetime
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, create_access_token, create_refresh_token, get_jwt_identity
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
        access_token = create_access_token(identity=str(user.id))
        refresh_token = create_refresh_token(identity=str(user.id))
        return jsonify({"access_token": access_token, "refresh_token":refresh_token, "user_id": user.id}), 200
    return jsonify({"message": "Invalid username or password"}), 401

# Refresh JWT
@bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    identity = get_jwt_identity()
    access_token = create_access_token(identity=str(identity))
    return jsonify({"access_token": access_token}), 200

# Get Current User
@bp.route('/user', methods=['GET'])
@jwt_required()
def get_current_user():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    return jsonify(user.to_dict())

# Add Transaction
@bp.route('/transaction', methods=['POST'])
@jwt_required()
def add_transaction():
    user_id = get_jwt_identity()
    data = request.get_json()

    amount = data['amount']
    description = data['description']
    category = data['category']
    account = data['account']
    type = data['type']
    timestamp = datetime.fromisoformat(data['timestamp'])

    new_transaction = Transaction(
        amount = amount,
        description = description,
        category = category,
        account = account,
        type = type,
        timestamp = timestamp
    )

    db.session.add(new_transaction)

    account_to_change = Account.query.filter_by(name=account, user_id=user_id).first()

    if type == 'Income':
        account_to_change.balance += float(amount)
    elif type == 'Expense':
        account_to_change.balance -= float(amount)

    db.session.commit()

    return jsonify(new_transaction.to_dict()), 201

# Get Transactions
@bp.route('/transactions', methods=['GET'])
@jwt_required()
def get_transactions():
    user_id = get_jwt_identity()

    accounts = Account.query.filter_by(user_id=user_id).all()
    acct_names = []
    for acct in accounts:
        acct_names.append(acct.to_dict()['name'])

    transactions = Transaction.query.filter(Transaction.account.in_(acct_names)).all()
    return jsonify([t.to_dict() for t in transactions])

# Get Transactions by Account
@bp.route('/transactions/<account>', methods=['GET'])
@jwt_required()
def get_transactions_by_account(account):
    user_id = get_jwt_identity()
    transactions = Transaction.query.filter_by(account=account).all()
    return jsonify([t.to_dict() for t in transactions])

# Update Transaction by ID
@bp.route('/transaction/<id>', methods=['PUT'])
@jwt_required()
def update_transaction(id):
    user_id = get_jwt_identity()
    data = request.get_json()

    transaction = Transaction.query.get(id)

    account_to_change = Account.query.filter_by(name=transaction.account, user_id=user_id).first()

    if transaction.type == 'Income':
        account_to_change.balance -= float(transaction.amount)
    elif transaction.type == 'Expense':
        account_to_change.balance += float(transaction.amount)

    if not transaction:
        return jsonify({'message': 'Transaction not found'}), 404

    if transaction.account not in [a.to_dict()['name'] for a in Account.query.filter_by(user_id=int(user_id)).all()]:
        return jsonify({'message': 'Unauthorized'}), 401

    transaction.amount = data['amount']
    transaction.description = data['description']
    transaction.category = data['category']
    transaction.account = data['account']
    transaction.type = data['type']
    transaction.timestamp = datetime.fromisoformat(data['timestamp'])

    if transaction.type == 'Income':
        account_to_change.balance += float(transaction.amount)
    elif transaction.type == 'Expense':
        account_to_change.balance -= float(transaction.amount)

    db.session.commit()

    return jsonify(transaction.to_dict())

# Delete Transaction by ID
@bp.route('/transaction/<id>', methods=['DELETE'])
@jwt_required()
def delete_transaction(id):
    user_id = get_jwt_identity()

    transaction = Transaction.query.get(id)

    account_to_change = Account.query.filter_by(name=transaction.account, user_id=user_id).first()

    if not transaction:
        return jsonify({'message': 'Transaction not found'}), 404

    if transaction.account not in [a.to_dict()['name'] for a in Account.query.filter_by(user_id=int(user_id)).all()]:
        return jsonify({'message': 'Unauthorized'}), 401

    db.session.delete(transaction)

    if transaction.type == 'Income':
        account_to_change.balance -= float(transaction.amount)
    elif transaction.type == 'Expense':
        account_to_change.balance += float(transaction.amount)

    db.session.commit()

    return jsonify({'message': 'Transaction deleted'})

# Add Account
@bp.route('/account', methods=['POST'])
@jwt_required()
def add_account():
    user_id = get_jwt_identity()
    data = request.get_json()

    name = data['name']
    description = data['description']
    type = data['type']
    balance = data['balance']
    apy = data['apy'] if 'apy' in data else 0

    existing_account = Account.query.filter_by(user_id=user_id, name=name).first()

    if existing_account:
        return jsonify({'message': 'Account with name already exists'}), 400
    
    new_account = Account(
        user_id = user_id,
        name = name,
        description = description,
        type = type,
        balance = balance,
        apy = apy
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

# Update Account by ID
@bp.route('/account/<id>', methods=['PUT'])
@jwt_required()
def update_account(id):
    user_id = get_jwt_identity()
    data = request.get_json()

    account = Account.query.get(id)

    if not account:
        return jsonify({'message': 'Account not found'}), 404

    if account.user_id != int(user_id):
        return jsonify({'message': 'Unauthorized'}), 401

    account.name = data['name']
    account.description = data['description']
    account.type = data['type']
    account.balance = data['balance']
    account.apy = data['apy']

    db.session.commit()

    return jsonify(account.to_dict())

# Delete Account by ID
@bp.route('/account/<id>', methods=['DELETE'])
@jwt_required()
def delete_account(id):
    user_id = get_jwt_identity()

    account = Account.query.get(id)

    if not account:
        return jsonify({'message': 'Account not found'}), 404

    if account.user_id != int(user_id):
        return jsonify({'message': 'Unauthorized'}), 401

    db.session.delete(account)
    db.session.commit()

    return jsonify({'message': 'Account deleted'})