CREATE DATABASE ETL_Assignment;
USE ETL_Assignment;
CREATE TABLE Sales_Transactions (
    Txn_ID INT,
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(50),
    Product_ID VARCHAR(10),
    Quantity INT,
    Txn_Amount DECIMAL(10,2),
    Txn_Date DATE,
    City VARCHAR(50)
);
CREATE TABLE Customers_Master (
    CustomerID VARCHAR(10),
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);
INSERT INTO Customers_Master VALUES
('C101', 'Rahul Mehta', 'Mumbai'),
('C102', 'Anjali Rao', 'Bengaluru'),
('C103', 'Suresh Iyer', 'Chennai'),
('C104', 'Neha Singh', 'Delhi');
INSERT INTO Sales_Transactions VALUES
(201, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(202, 'C102', 'Anjali Rao', 'P12', 1, 1500, '2025-12-01', 'Bengaluru'),
(203, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(204, 'C103', 'Suresh Iyer', 'P13', 3, 6000, '2025-12-02', 'Chennai'),
(205, 'C104', 'Neha Singh', 'P14', NULL, 2500, '2025-12-02', 'Delhi'),
(206, 'C105', 'N/A', 'P15', 1, NULL, '2025-12-03', 'Pune'),
(207, 'C106', 'Amit Verma', 'P16', 1, 1800, NULL, 'Pune'),
(208, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai');

SELECT * FROM Sales_Transactions;
SELECT * FROM Customers_Master;

question -7
– Duplicate Business Key
SELECT 
    Customer_ID,
    Product_ID,
    Txn_Date,
    Txn_Amount,
    COUNT(*) AS duplicate_count
FROM Sales_Transactions
GROUP BY 
    Customer_ID,
    Product_ID,
    Txn_Date,
    Txn_Amount
HAVING COUNT(*) > 1;
 Q8 – Referential Integrity Violation
 
 SELECT DISTINCT st.Customer_ID
FROM Sales_Transactions st
LEFT JOIN Customers_Master cm
    ON st.Customer_ID = cm.CustomerID
WHERE cm.CustomerID IS NULL;
SELECT * 
FROM Sales_Transactions
WHERE Quantity IS NULL 
   OR Txn_Amount IS NULL 
   OR Txn_Date IS NULL;
   
  -- Question 1:
   -- Define Data Quality in ETL. Why is it more than just cleaning?
-- Data Quality in ETL refers to how accurate, complete, consistent, valid, unique, and timely the data is as it flows through Extract → Transform → Load.

It is more than data cleaning because:
Cleaning = fixing errors (nulls, typos, duplicates)
Data Quality = preventing + measuring + governing + validating
It includes:
Validation rules
Monitoring metrics
Integrity checks
Standardization
Business rule enforcement
-- Cleaning is reactive; Data Quality is proactive + continuous.

Question 2: Why poor data quality leads to misleading dashboards?

Poor data quality causes:

Wrong aggregations

Incorrect KPIs

Misleading trends

False insights

Example:
If duplicates exist → Revenue doubles → Business thinks sales increased.

Outcome:
Wrong decisions
Financial losses
Strategy failures

Garbage In → Garbage Out (GIGO)

Question 3: What is duplicate data? Three causes in ETL

Duplicate Data = Same record appearing multiple times.

Causes:

1 Multiple Source Loads
Same file/API loaded repeatedly.

2 Missing Business Key Constraints
No uniqueness checks.

3 Improper Joins / Transformations
Cartesian joins creating duplicates.

Other causes:

Retry failures

Late arriving data

CDC misconfigurations

Question 4: Exact vs Partial vs Fuzzy duplicates
Type	Meaning	Example
Exact	Fully identical rows	Same Customer_ID, Product_ID, Amount
Partial	Some fields differ	Same ID but different City
Fuzzy	Similar but not identical	“Rahul Mehta” vs “R. Mehta”
Question 5: Why validate during transformation?

Validation during Transformation is better because:

Errors caught early
Prevents corrupt warehouse
Saves reprocessing cost
Easier correction

If done after loading:

Bad data already impacts reports
Costly rollback

Best Practice = Validate before Load

Question 6: Business Rules & Example
Business Rules = Logical constraints based on domain knowledge.
Example Rules:
Txn_Amount > 0
Quantity NOT NULL
Txn_Date NOT NULL
Example from dataset:
C105 → Txn_Amount = NULL 
C104 → Quantity = NULL 
C106 → Txn_Date = NULL
Business rules help detect:
Invalid values
Missing fields