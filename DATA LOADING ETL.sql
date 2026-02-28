
CREATE DATABASE ETL_Assignment;
USE ETL_Assignment;

CREATE TABLE Sales_Data (
    Order_ID VARCHAR(10),
    Customer_ID VARCHAR(10),
    Sales_Amount VARCHAR(30),
    Order_Date VARCHAR(20)
);


INSERT INTO Sales_Data VALUES
('O101', 'C001', '4500', '12-01-2024'),
('O102', 'C002', NULL, '15-01-2024'),
('O103', 'C003', '3200', '2024/01/18'),
('O101', 'C001', '4500', '12-01-2024'),
('O104', 'C004', 'Three Thousand', '20-01-2024'),
('O105', 'C005', '5100', '25-01-2024');

SELECT * FROM Sales_Data;


/* =====================================================
   Q1: DATA QUALITY CHECKS
   ===================================================== */

-- Duplicate Order_ID
SELECT Order_ID, COUNT(*) AS cnt
FROM Sales_Data
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Missing Values
SELECT *
FROM Sales_Data
WHERE Sales_Amount IS NULL
   OR Order_Date IS NULL
   OR Customer_ID IS NULL;

/* =====================================================
   Q2: PRIMARY KEY VIOLATION (Order_ID)
   ===================================================== */

SELECT Order_ID, COUNT(*) AS cnt
FROM Sales_Data
GROUP BY Order_ID
HAVING COUNT(*) > 1;


/* =====================================================
   Q3: MISSING Sales_Amount
   ===================================================== */

SELECT *
FROM Sales_Data
WHERE Sales_Amount IS NULL;


/* =====================================================
   Q4: INVALID NUMERIC Sales_Amount
   ===================================================== */

SELECT *
FROM Sales_Data
WHERE Sales_Amount NOT REGEXP '^[0-9]+$'
   OR Sales_Amount IS NULL;


/* =====================================================
   Q5: INCONSISTENT DATE FORMAT
   ===================================================== */

SELECT *
FROM Sales_Data
WHERE Order_Date NOT REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';


/* =====================================================
   Q6: LOAD READINESS VALIDATION
   ===================================================== */

SELECT *
FROM Sales_Data
WHERE Order_ID IS NULL
   OR Sales_Amount IS NULL
   OR Sales_Amount NOT REGEXP '^[0-9]+$'
   OR Order_Date NOT REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';


/* =====================================================
   Q8: CLEANING OPERATIONS
   ===================================================== */

-- Fix invalid numeric value
UPDATE Sales_Data
SET Sales_Amount = '3000'
WHERE Sales_Amount = 'Three Thousand';

-- Fix NULL Sales_Amount
UPDATE Sales_Data
SET Sales_Amount = '0'
WHERE Sales_Amount IS NULL;

-- Remove duplicate Order_ID (keep one)
DELETE FROM Sales_Data
WHERE Order_ID = 'O101'
LIMIT 1



SELECT * FROM Sales_Data;

-- Recheck invalid numeric
SELECT *
FROM Sales_Data
WHERE Sales_Amount NOT REGEXP '^[0-9]+$';

-- Recheck NULLs
SELECT *
FROM Sales_Data
WHERE Sales_Amount IS NULL;


CREATE TABLE Clean_Sales_Data AS
SELECT
    Order_ID,
    Customer_ID,
    CAST(Sales_Amount AS DECIMAL(10,2)) AS Sales_Amount,
    STR_TO_DATE(Order_Date, '%d-%m-%Y') AS Order_Date
FROM Sales_Data;


SELECT * FROM Clean_Sales_Data;




SELECT SUM(Sales_Amount) AS Total_Sales
FROM Clean_Sales_Data;

Data Understanding
Theory Answer:
Dataset me following data quality issues hain:

Duplicate Order_ID → O101
Missing values → NULL Sales_Amount
Invalid numeric value → "Three Thousand"
Inconsistent date format → DD-MM-YYYY & YYYY/MM/DD

Q2. Primary Key Validation
Theory:
Primary Key rules:
Unique
NOT NULL
Dataset violates rule because
Order_ID O101 duplicated
Q3. Missing Value Analysis
Theory:

Column with missing value:

Sales_Amount

Affected Record:
O102
Risk:
Incorrect totals
 BI errors
Constraint violation
q-4
Data Type Validation
Theory:

Expected → Numeric
Invalid → "Three Thousand"
Impact:
Load failure
CAST error

Q5. Date Format Consistency
Theory:

Formats present:

12-01-2024 → DD-MM-YYYY

2024/01/18 → YYYY/MM/DD

Problem:

Parsing error
Wrong sorting

Q6. Load Readiness Decision
Theory:

Dataset should NOT be loaded directly.

Reasons:

Duplicate PK
NULL values
Invalid numeric
Mixed date formats

Q7. Pre-Load Validation Checklist
Theory:

Before load:

Duplicate check
NULL check
Numeric validation
Date validation
PK validation

Q8. Cleaning Strategy
Theory:

Steps:

Remove duplicates
Handle NULL values
Fix invalid numeric
Standardize dates

Q9. Loading Strategy Selection
Theory:

Incremental Load

Why:

Faster
Efficient
Daily dataset
Q10. BI Impact Scenario
Theory:

If loaded without cleaning:

Duplicate O101 → double sales
NULL O102 → missing revenue
Text O104 → ignored/error

BI tools fail because:

They assume DB is clean
No deep validation