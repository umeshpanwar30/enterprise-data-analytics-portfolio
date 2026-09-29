-- LEVEL 1: CLEANING AND INITIALIZING THE CORPORATE FINANCE LEDGER
DROP TABLE IF EXISTS monthly_operating_budgets CASCADE;
DROP TABLE IF EXISTS finance_cash_ledger CASCADE;

-- 1. FINANCE CASH TRANSACTION LEDGER (Raw Accounts Pipeline)
CREATE TABLE finance_cash_ledger (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE NOT NULL,
    account_type VARCHAR(30) NOT NULL CHECK (account_type IN ('Gross Revenue', 'Operating Expense', 'Marketing Cost', 'Taxation Outflow')),
    amount_gbp DECIMAL(12, 2) NOT NULL CHECK (amount_gbp >= 0),
    department VARCHAR(50) NOT NULL DEFAULT 'Corporate Core'
);

-- 2. OPERATING TARGET BUDGET MATRIX (Corporate Financial Planning)
CREATE TABLE monthly_operating_budgets (
    budget_id SERIAL PRIMARY KEY,
    budget_month DATE NOT NULL UNIQUE, -- (First day of each tracking month)
    target_net_margin_pct DECIMAL(5, 2) NOT NULL CHECK (target_net_margin_pct BETWEEN 0 AND 100)
);

-- INJECTING ENTERPRISE TRANSACTION RECORDS (Simulating Multi-Month Trends 2026)
INSERT INTO finance_cash_ledger (transaction_date, account_type, amount_gbp, department) VALUES
-- January Performance Cycle
('2026-01-05', 'Gross Revenue', 8500.00, 'E-Commerce Storefront'),
('2026-01-12', 'Operating Expense', 2200.00, 'Warehouse Logistics'),
('2026-01-20', 'Marketing Cost', 1500.00, 'Paid Social Media Ads'),
('2026-01-28', 'Taxation Outflow', 850.00, 'Corporate Core Compliance'),
-- February Performance Cycle
('2026-02-04', 'Gross Revenue', 9200.00, 'E-Commerce Storefront'),
('2026-02-14', 'Operating Expense', 2400.00, 'Warehouse Logistics'),
('2026-02-18', 'Marketing Cost', 3000.00, 'Influencer Campaigns Campaign'), -- High marketing load!
('2026-02-25', 'Taxation Outflow', 920.00, 'Corporate Core Compliance'),
-- March Performance Cycle
('2026-03-03', 'Gross Revenue', 12500.00, 'E-Commerce Storefront'), -- Sales Spike!
('2026-03-12', 'Operating Expense', 2300.00, 'Warehouse Logistics'),
('2026-03-19', 'Marketing Cost', 1800.00, 'Paid Social Media Ads'),
('2026-03-27', 'Taxation Outflow', 1250.00, 'Corporate Core Compliance');

-- INJECTING TARGET CORPORATE PLAN GOALS (Net Margins Minimum Targets)
INSERT INTO monthly_operating_budgets (budget_month, target_net_margin_pct) VALUES
('2026-01-01', 40.00), -- Target 40% efficiency for Jan
('2026-02-01', 45.00), -- Target 45% efficiency for Feb
('2026-03-01', 45.00); -- Target 45% efficiency for March
