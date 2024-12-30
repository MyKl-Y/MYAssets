<h1>
m.y Assets
</h1>
A robust and scalable Flutter application for managing user accounts, budgets, and transactions with secure backend authentication, including Google OAuth2 integration.

## Features

- **User Registration and Login**:
  - Traditional username and password authentication.
  - Google Sign-In for seamless login.

- **Account Management**:
  - Add, view, and manage accounts with real-time balance updates.

- **Transaction Management**:
  - Add, view, and categorize transactions.
  - Supports income and expense tracking with auto-balance adjustment.

- **Secure Backend**:
  - JWT-based authentication with token refresh support.
  - Secure API endpoints for managing users, accounts, and transactions.

- **Responsive Design**:
  - Optimized for web, desktop, and mobile platforms.

---

## Tech Stack

### **Frontend**
- [Flutter](https://flutter.dev/) (Dart) for building the UI.
- [Provider](https://pub.dev/packages/provider) for state management.
- [google_sign_in](https://pub.dev/packages/google_sign_in) for Google OAuth2 authentication.

### **Backend**
- [Flask](https://flask.palletsprojects.com/) for the REST API.
- [Flask-JWT-Extended](https://flask-jwt-extended.readthedocs.io/) for JWT-based authentication.
- [SQLAlchemy](https://www.sqlalchemy.org/) for database interactions.
- [Google Auth Library](https://google-auth.readthedocs.io/) for Google OAuth2 validation.

---

## Installation

### **Frontend Setup**
1. Install [Flutter](https://docs.flutter.dev/get-started/install) on your machine.
2. Clone the repository:
   ```bash
   git clone https://github.com/MyKl-Y/MYAssets
   cd client
   ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Run the app:
    ```bash
    flutter run
    ```

### **Backend Setup**
1. Install Python 3.9 or higher.
2. Clone the repository:
    ```bash
    git clone https://github.com/MyKl-Y/MYAssets
    cd server
    ```
3. Create a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate # On Windows: venv\Scripts\activate
    ```
4. Create environment variables (in a `.env` file):
    ```.env
    SECRET_KEY=<your_secret_key>
    DATABASE_URL=<your_database_url>
    JWT_SECRET_KEY=<your_jwt_secret_key>
    ```
5. Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
6. Run the server:
    ```bash
    flask run
    ```

## Usage
1. Launch the Backend:
    - Run the Flask server:
        ```bash
        flask run
        ```
2. Run the Frontend:
    - Open a terminal in the client directory and run:
        ```bash
        flutter run
        ```
3. Login/Register:
    - Use the app to create an account or log in using Google OAuth2.
4. Add Accounts, Transactions, etc.
    - Navigate to the "Add" tab to manage accounts and transactions.

## API Endpoints
### Authentication
- `POST /login`: User login with username and password.
- `POST /register`: User registration.
- `POST /google-login`: Google OAuth2 login.
- `POST /refresh`: Refresh JWT access token.

### User
- `GET /user`: Fetch the logged-in user.

### Accounts
- `GET /accounts`: Retrieve all user accounts.
- `POST /accounts`: Add a new account.
- `PUT /account/<id>`: Updates an account by its ID.
- `DELETE /account/<id>`: Deletes an account by its ID.

### Transactions
- `GET /transactions`: Retrieve all user transactions.
- `GET /transactions/<account>`: Retrieve all transactions for a given account.
- `POST /transactions`: Add a new transaction.
- `PUT /transaction/<id>`: Updates a transaction by its ID.
- `DELETE /transaction/<id>`: Deletes a transaction by uts ID.

## Google OAuth2 Setup
1. Create a new project in the Google Cloud Console.
2. Enable the Google Identity Services API.
3. Configure OAuth2 credentials and authorized redirect URIs:
    - Backend: `http://127.0.0.1:42069`
    - Frontend: Add any necessary mobile or web platform configurations.
4. Replace `"YOUR_GOOGLE_CLIENT_ID"` in the backend code with your client ID.

## Folder Structure
```bash
project/
├── client/                # Flutter frontend
│   ├── lib/
│   │   ├── screens/       # UI screens
│   │   ├── widgets/       # Reusable components
│   │   ├── services/      # API service integration
│   │   └── utils/         # State management and helpers
│   ├── pubspec.yaml       # Frontend dependencies
│   └── assets/            # Assets
│       └── images/        # Images
├── server/                # Flask backend
│   ├── app/
│   │   ├── api.py         # API routes
│   │   ├── models.py      # Database models
│   │   └── utils.py       # Utility functions
│   └── requirements.txt   # Backend dependencies
├── README.md              # Project documentation
└── todo.md                # List of features to implement
```

## Contributing
1. Fork the repository
2. Create a new branch:
    ```bash
    git checkout -b feature-name
    ```
3. Commit your changes:
    ```bash
    git commit -m "Add feature-name..."
    ```
4. Push to the branch:
    ```bash
    git push origin feature-name
    ```
5. Open a pull request.

## Contact
For questions or support, please reach out to the maintainer(s):
- Email: michaelyyim@gmail.com
- GitHub: [MyKl-Y](https://github.com/MyKl-Y)