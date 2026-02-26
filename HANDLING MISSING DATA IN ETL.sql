CREATE DATABASE Pwskills_ETL;
USE Pwskills_ETL;
CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Monthly_Sales INT,
    Income INT,
    Region VARCHAR(20)
);

INSERT INTO customers VALUES
(101, 'Rahul Mehta', 'Mumbai', 12000, 65000, 'West'),
(104, 'Neha Singh', 'Delhi', NULL, NULL, 'North'),
(102, 'Anjali Rao', 'Bengaluru', NULL, NULL, 'South'),
(105, 'Amit Verma', 'Pune', 18000, 58000, NULL),
(107, 'Pooja Das', 'Kolkata', 14000, NULL, 'East'),
(103, 'Suresh Iyer', 'Chennai', 15000, 72000, 'South'),
(106, 'Karan Shah', 'Ahmedabad', NULL, 61000, 'West'),
(108, 'Riya Kapoor', 'Jaipur', 16000, 69000, 'North');
-- question 8
SELECT *
FROM customers
WHERE Region IS NOT NULL;
SELECT COUNT(*) AS Records_Lost
FROM customers
WHERE Region IS NULL;

-- question 9

SELECT
    Customer_ID,
    Name,
    City,
    Monthly_Sales,
    COALESCE(
        Monthly_Sales,
        MAX(Monthly_Sales) OVER (
            ORDER BY Customer_ID
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        )
    ) AS Forward_Filled_Sales,
    Income,
    Region
FROM customers;

-- question 10

SELECT
    Customer_ID,
    Name,
    City,
    Monthly_Sales,
    Income,
    Region,
    CASE
        WHEN Income IS NULL THEN 1
        ELSE 0
    END AS Income_Missing_Flag
FROM customers;

-- Q1. Most common reasons for missing data in ETL pipelines

-- Data entry errors

Optional fields left blank

System / sensor failures

Integration issues between sources

Corrupted or lost records

Different schema across systems

-- Q2. Why blindly deleting rows is bad

Causes data loss

Reduces sample size

Introduces bias

May remove important patterns

Distorts analytics & ML models

-- Q3. Listwise vs Column Deletion
Listwise Deletion
→ Remove rows with missing values
✔ Appropriate when:
Very few rows affected
Missing data is random
Column Deletion
→ Remove entire column
✔ Appropriate when:
Column has too many missing values
Column not critical for analysis

-- Q4. Median vs Mean (skewed data)

Median is preferred because:

Resistant to outliers

Represents central tendency better

Mean gets distorted in skewed distributions (like income)

-- Q5. Forward Fill

Forward Fill = Replace missing values with previous valid value
✔ Useful in:
Time-series data
Sequential records
Sales / stock / sensor datasets

-- Q6. Why flag missing before imputation
Preserves missingness information
Missing data itself may hold patterns
Helps ML models detect anomalies
Enables business insights

--Q7. Missing income → Business insights
Missing income may indicate:
Customers unwilling to disclose income
Certain demographic segment
Data collection issue
Privacy-sensitive customers
Potential high/low income group pattern
SECTION B – PRACTICAL
Given Dataset (Original)
ID	Name	City	Monthly_Sales	Income	Region
101	Rahul Mehta	Mumbai	12000	65000	West
104	Neha Singh	Delhi	NaN	NaN	North
102	Anjali Rao	Bengaluru	NaN	NaN	South
105	Amit Verma	Pune	18000	58000	NaN
107	Pooja Das	Kolkata	14000	NaN	East
103	Suresh Iyer	Chennai	15000	72000	South
106	Karan Shah	Ahmedabad	NaN	61000	West
108	Riya Kapoor	Jaipur	16000	69000	North
-- Q8. Listwise Deletion (Remove missing Region)
Affected Row

Customer 105 (Amit Verma)

Dataset After Deletion
ID	Name	City	Monthly_Sales	Income	Region
101	Rahul Mehta	Mumbai	12000	65000	West
104	Neha Singh	Delhi	NaN	NaN	North
102	Anjali Rao	Bengaluru	NaN	NaN	South
107	Pooja Das	Kolkata	14000	NaN	East
103	Suresh Iyer	Chennai	15000	72000	South
106	Karan Shah	Ahmedabad	NaN	61000	West
108	Riya Kapoor	Jaipur	16000	69000	North
Records Lost: 1
-- Q9. Imputation – Forward Fill (Monthly_Sales)
Before → After
ID	Name	Before	After
104	Neha Singh	NaN	12000
102	Anjali Rao	NaN	12000
106	Karan Shah	NaN	15000
Explanation

Forward fill suitable because:

Data appears sequential

Sales often follow time/order continuity

Prevents unrealistic averages

-- Q10. Flagging Missing Income
Income_Missing_Flag

(0 = Present, 1 = Missing)

ID	Name	Income	Flag
101	Rahul Mehta	65000	0
104	Neha Singh	NaN	1
102	Anjali Rao	NaN	1
105	Amit Verma	58000	0
107	Pooja Das	NaN	1
103	Suresh Iyer	72000	0
106	Karan Shah	61000	0
108