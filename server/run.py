# server/run.py

'''
Entry Point
'''

from app import create_app, db
from flask_migrate import Migrate

app = create_app()
migrate = Migrate(app, db)

if __name__ == '__main__':
    app.run(
        debug=True,
        host='0.0.0.0',
        port=42069
    )