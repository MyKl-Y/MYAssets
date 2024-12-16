# server/app/routes/__init__.py

'''
Main Blueprint
'''

from flask import Blueprint

# Initialize Blueprints for modular routes
bp = Blueprint('main', __name__)

# Import and register routes
from . import api
