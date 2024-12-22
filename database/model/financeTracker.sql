-- Create User table
CREATE TABLE User (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Create Account table
CREATE TABLE Account (
    account_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_bank VARCHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    type VARCHAR(50) NOT NULL, -- e.g., Savings, Checking
    apy DECIMAL(5, 2), -- Annual Percentage Yield for Savings accounts
    CONSTRAINT fk_user_account FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
);

-- Create Transaction table
CREATE TABLE Transaction (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_desc VARCHAR(255),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    balance DECIMAL(15, 2) NOT NULL, -- Account balance after the transaction
    amount DECIMAL(15, 2) NOT NULL, -- Amount credited or debited
    category VARCHAR(100) NOT NULL, -- e.g., Salary, Food, Housing
    type VARCHAR(50) NOT NULL, -- e.g., Income, Expense
    CONSTRAINT fk_account_transaction FOREIGN KEY (account_id) REFERENCES Account (account_id) ON DELETE CASCADE
);

-- Create Budget table
CREATE TABLE Budget (
    budget_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    budget_name VARCHAR(100) NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    categories TEXT NOT NULL, -- Categories can be stored as a comma-separated string or JSON
    CONSTRAINT fk_user_budget FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
);
