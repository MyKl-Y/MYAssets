# server/app/models.py

'''
Database Models
'''

from . import db
from sqlalchemy import Integer, String, Float, DateTime, Column, ForeignKey
from sqlalchemy.orm import validates
from datetime import datetime, timezone
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

class User(UserMixin, db.Model):
    id = Column(Integer, primary_key=True)
    username = Column(String(64), unique=True, nullable=False)
    email = Column(String(120), unique=True, nullable=False)
    password_hash = Column(String(128))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email
        }

class Account(db.Model):
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    name = Column(String(64), nullable=False)
    description = Column(String(256))
    type = Column(String(64), nullable=False)
    balance = Column(Float, nullable=False)
    created_at = Column(DateTime, index=True, default=datetime.now(timezone.utc))
    updated_at = Column(DateTime, index=True, default=datetime.now(timezone.utc), onupdate=datetime.now(timezone.utc))

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'name': self.name,
            'description': self.description,
            'type': self.type,
            'balance': self.balance,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

class Transaction(db.Model):
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    amount = Column(Float, nullable=False)
    description = Column(String(256))
    category = Column(String(64), nullable=False)
    account = Column(String(64))
    type = Column(String(64), nullable=False)
    apy = Column(Float)
    timestamp = Column(DateTime, index=True, default=datetime.now(timezone.utc))

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Only set the timestamp if not already set
        if 'timestamp' not in kwargs:
            self.timestamp = datetime.now(timezone.utc)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'amount': self.amount,
            'category': self.category,
            'timestamp': self.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
            'description': self.description,
            'account': self.account,
            'type': self.type,
        }
    
    @validates('type')
    def validate_type(self, key, transaction_type):
        if transaction_type not in ['Income', 'Expense']:
            raise ValueError("Transaction type must be 'Income' or 'Expense")
        return transaction_type
    
    @validates('category')
    def validate_category(self, key, category):
        allowed_categories = {
            'Income': ['Salary', 'Gift', 'Interest', 'Other'],
            'Expense': [
                'Housing', 'Food', 'Transportation', 'Utilities',
                'Medical', 'Education', 'Childcare', 'Subscriptions', 'Other'
            ]
        }
        if self.type and category not in allowed_categories.get(self.type, []):
            raise ValueError(f"Category '{category}' is not valid for transaction type '{self.type}'")
        return category

class Budget(db.Model):
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    name = Column(String(64), nullable=False)
    total_amount = Column(Float, nullable=False)
    start_date = Column(DateTime, nullable=False)
    end_date = Column(DateTime, nullable=False)
    categories = Column(String(256), nullable=False)
    created_at = Column(DateTime, index=True, default=datetime.now(timezone.utc))
    updated_at = Column(DateTime, index=True, default=datetime.now(timezone.utc), onupdate=datetime.now(timezone.utc))

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "name": self.name,
            "total_amount": self.total_amount,
            "start_date": self.start_date.strftime('%Y-%m-%d'),
            "end_date": self.end_date.strftime('%Y-%m-%d'),
            "categories": self.categories.split(',') if self.categories else [],
            "created_at": self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            "updated_at": self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }
