-- ============================================================
-- CREDIT CARD FRAUD DETECTION - SQL ANALYSIS
-- Database: MySQL
-- Dataset: Credit Card Transactions
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS credit_card_fraud;

USE credit_card_fraud;


-- ============================================================
-- 2. CREATE TRANSACTION TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS credit_card_transactions (
    Time DOUBLE,
    V1 DOUBLE,
    V2 DOUBLE,
    V3 DOUBLE,
    V4 DOUBLE,
    V5 DOUBLE,
    V6 DOUBLE,
    V7 DOUBLE,
    V8 DOUBLE,
    V9 DOUBLE,
    V10 DOUBLE,
    V11 DOUBLE,
    V12 DOUBLE,
    V13 DOUBLE,
    V14 DOUBLE,
    V15 DOUBLE,
    V16 DOUBLE,
    V17 DOUBLE,
    V18 DOUBLE,
    V19 DOUBLE,
    V20 DOUBLE,
    V21 DOUBLE,
    V22 DOUBLE,
    V23 DOUBLE,
    V24 DOUBLE,
    V25 DOUBLE,
    V26 DOUBLE,
    V27 DOUBLE,
    V28 DOUBLE,
    Amount DOUBLE,
    Class INT
);


-- ============================================================
-- 3. DATA IMPORT
-- ============================================================
-- The dataset can be imported using LOAD DATA LOCAL INFILE.
-- Update the file path according to your local computer.
--
-- Example:
--
-- LOAD DATA LOCAL INFILE
-- 'C:/path/to/Credit-Card-Fraud-Detection/Dataset/creditcard_sql.csv'
-- INTO TABLE credit_card_transactions
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;


-- ============================================================
-- 4. ADD DERIVED COLUMNS
-- ============================================================

ALTER TABLE credit_card_transactions
ADD COLUMN Hour DOUBLE,
ADD COLUMN Amount_Range VARCHAR(20);


-- ============================================================
-- 5. CALCULATE TRANSACTION HOUR
-- ============================================================

UPDATE credit_card_transactions
SET Hour = MOD(Time / 3600, 24);


-- ============================================================
-- 6. CREATE TRANSACTION AMOUNT RANGES
-- ============================================================

UPDATE credit_card_transactions
SET Amount_Range =
    CASE
        WHEN Amount <= 50 THEN '0-50'
        WHEN Amount <= 100 THEN '50-100'
        WHEN Amount <= 250 THEN '100-250'
        WHEN Amount <= 500 THEN '250-500'
        WHEN Amount <= 1000 THEN '500-1000'
        ELSE '1000+'
    END;


-- ============================================================
-- 7. DATA QUALITY CHECK
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS null_time,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS null_class,
    SUM(CASE WHEN Hour IS NULL THEN 1 ELSE 0 END) AS null_hour,
    SUM(CASE WHEN Amount_Range IS NULL THEN 1 ELSE 0 END) AS null_amount_range
FROM credit_card_transactions;


-- ============================================================
-- 8. TOTAL TRANSACTIONS
-- ============================================================

SELECT
    COUNT(*) AS total_transactions
FROM credit_card_transactions;


-- ============================================================
-- 9. FRAUD VS LEGITIMATE TRANSACTIONS
-- ============================================================

SELECT
    Class,
    COUNT(*) AS transaction_count
FROM credit_card_transactions
GROUP BY Class;


-- ============================================================
-- 10. FRAUD PERCENTAGE
-- ============================================================

SELECT
    ROUND(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        3
    ) AS fraud_percentage
FROM credit_card_transactions;


-- ============================================================
-- 11. TOTAL TRANSACTION AMOUNT
-- ============================================================

SELECT
    ROUND(SUM(Amount), 2) AS total_transaction_amount
FROM credit_card_transactions;


-- ============================================================
-- 12. AVERAGE AND TOTAL AMOUNT BY CLASS
-- ============================================================

SELECT
    Class,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Amount), 2) AS average_amount,
    ROUND(SUM(Amount), 2) AS total_amount
FROM credit_card_transactions
GROUP BY Class;


-- ============================================================
-- 13. FRAUD TRANSACTIONS BY AMOUNT RANGE
-- ============================================================

SELECT
    Amount_Range,
    COUNT(*) AS fraud_transactions,
    ROUND(AVG(Amount), 2) AS average_amount,
    ROUND(SUM(Amount), 2) AS total_fraud_amount
FROM credit_card_transactions
WHERE Class = 1
GROUP BY Amount_Range
ORDER BY fraud_transactions DESC;


-- ============================================================
-- 14. FRAUD RATE BY AMOUNT RANGE
-- ============================================================

SELECT
    Amount_Range,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS fraud_transactions,
    ROUND(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        3
    ) AS fraud_rate
FROM credit_card_transactions
GROUP BY Amount_Range
ORDER BY fraud_rate DESC;


-- ============================================================
-- 15. FRAUD ANALYSIS BY HOUR
-- ============================================================

SELECT
    FLOOR(Hour) AS transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(Class) AS fraud_transactions,
    ROUND(
        SUM(Class) * 100.0 / COUNT(*),
        3
    ) AS fraud_rate
FROM credit_card_transactions
GROUP BY FLOOR(Hour)
ORDER BY fraud_rate DESC;


-- ============================================================
-- 16. TOP 10 FRAUD TRANSACTIONS
-- ============================================================

SELECT
    Time,
    Amount,
    Hour,
    Amount_Range
FROM credit_card_transactions
WHERE Class = 1
ORDER BY Amount DESC
LIMIT 10;


-- ============================================================
-- 17. HIGHEST FRAUD TRANSACTION AMOUNT
-- ============================================================

SELECT
    ROUND(MAX(Amount), 2) AS highest_fraud_amount
FROM credit_card_transactions
WHERE Class = 1;


-- ============================================================
-- 18. CLASS SUMMARY
-- ============================================================

SELECT
    Class,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM credit_card_transactions),
        3
    ) AS transaction_percentage,
    ROUND(AVG(Amount), 2) AS average_amount,
    ROUND(SUM(Amount), 2) AS total_amount
FROM credit_card_transactions
GROUP BY Class
ORDER BY Class;


-- ============================================================
-- 19. CTE - FRAUD SUMMARY BY AMOUNT RANGE
-- ============================================================

WITH fraud_summary AS (
    SELECT
        Amount_Range,
        COUNT(*) AS fraud_count,
        ROUND(AVG(Amount), 2) AS avg_fraud_amount,
        ROUND(SUM(Amount), 2) AS total_fraud_amount
    FROM credit_card_transactions
    WHERE Class = 1
    GROUP BY Amount_Range
)
SELECT
    Amount_Range,
    fraud_count,
    avg_fraud_amount,
    total_fraud_amount
FROM fraud_summary
ORDER BY total_fraud_amount DESC;


-- ============================================================
-- 20. RANK FRAUD AMOUNT RANGES
-- ============================================================

WITH fraud_summary AS (
    SELECT
        Amount_Range,
        COUNT(*) AS fraud_count,
        ROUND(AVG(Amount), 2) AS avg_fraud_amount,
        ROUND(SUM(Amount), 2) AS total_fraud_amount
    FROM credit_card_transactions
    WHERE Class = 1
    GROUP BY Amount_Range
)
SELECT
    Amount_Range,
    fraud_count,
    avg_fraud_amount,
    total_fraud_amount,
    RANK() OVER (
        ORDER BY total_fraud_amount DESC
    ) AS amount_rank
FROM fraud_summary
ORDER BY amount_rank;


-- ============================================================
-- 21. TOP 10 FRAUD TRANSACTIONS USING ROW_NUMBER()
-- ============================================================

WITH ranked_fraud AS (
    SELECT
        Time,
        Amount,
        Hour,
        Amount_Range,
        ROW_NUMBER() OVER (
            ORDER BY Amount DESC
        ) AS transaction_rank
    FROM credit_card_transactions
    WHERE Class = 1
)
SELECT
    transaction_rank,
    Time,
    ROUND(Amount, 2) AS Amount,
    ROUND(Hour, 2) AS Hour,
    Amount_Range
FROM ranked_fraud
WHERE transaction_rank <= 10
ORDER BY transaction_rank;


-- ============================================================
-- 22. CTE - FRAUD RATE BY HOUR
-- ============================================================

WITH hourly_summary AS (
    SELECT
        FLOOR(Hour) AS transaction_hour,
        COUNT(*) AS total_transactions,
        SUM(Class) AS fraud_transactions
    FROM credit_card_transactions
    GROUP BY FLOOR(Hour)
)
SELECT
    transaction_hour,
    total_transactions,
    fraud_transactions,
    ROUND(
        fraud_transactions * 100.0 / total_transactions,
        3
    ) AS fraud_rate
FROM hourly_summary
ORDER BY fraud_rate DESC;


-- ============================================================
-- 23. COMBINED KPI QUERY
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,

    SUM(
        CASE WHEN Class = 1 THEN 1 ELSE 0 END
    ) AS total_fraud_transactions,

    SUM(
        CASE WHEN Class = 0 THEN 1 ELSE 0 END
    ) AS total_legitimate_transactions,

    ROUND(
        SUM(
            CASE WHEN Class = 1 THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),
        3
    ) AS fraud_percentage,

    ROUND(SUM(Amount), 2)
        AS total_transaction_amount,

    ROUND(
        AVG(
            CASE WHEN Class = 1 THEN Amount END
        ),
        2
    ) AS average_fraud_amount,

    ROUND(
        MAX(
            CASE WHEN Class = 1 THEN Amount END
        ),
        2
    ) AS highest_fraud_amount

FROM credit_card_transactions;


-- ============================================================
-- 24. FRAUD AMOUNT SHARE
-- ============================================================

SELECT
    ROUND(
        SUM(
            CASE WHEN Class = 1 THEN Amount ELSE 0 END
        ),
        2
    ) AS total_fraud_amount,

    ROUND(
        SUM(Amount),
        2
    ) AS total_transaction_amount,

    ROUND(
        SUM(
            CASE WHEN Class = 1 THEN Amount ELSE 0 END
        ) * 100.0 / SUM(Amount),
        3
    ) AS fraud_amount_percentage

FROM credit_card_transactions;


-- ============================================================
-- 25. FRAUD VS LEGITIMATE AMOUNT COMPARISON
-- ============================================================

SELECT
    CASE
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS transaction_type,

    COUNT(*) AS transaction_count,

    ROUND(AVG(Amount), 2) AS average_amount,

    ROUND(MIN(Amount), 2) AS minimum_amount,

    ROUND(MAX(Amount), 2) AS maximum_amount,

    ROUND(SUM(Amount), 2) AS total_amount

FROM credit_card_transactions

GROUP BY Class

ORDER BY Class;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================
