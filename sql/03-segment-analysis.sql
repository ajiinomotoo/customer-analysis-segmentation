USE customer_segmentation;


-- =========================================================
-- 1. CHECK TRANSACTION DATE RANGE
-- =========================================================

SELECT
    MIN(InvoiceDate) AS first_transaction,
    MAX(InvoiceDate) AS last_transaction
FROM online_retail;


-- =========================================================
-- 2. OUTLIER INVESTIGATION
-- =========================================================

-- Check extreme quantity and revenue values

SELECT
    MAX(Quantity) AS max_quantity,
    AVG(Quantity) AS avg_quantity,
    MAX(Revenue) AS max_revenue,
    AVG(Revenue) AS avg_revenue
FROM online_retail;


-- Top transactions by revenue

SELECT
    InvoiceNo,
    CustomerID,
    InvoiceDate,
    StockCode,
    Description,
    Quantity,
    UnitPrice,
    Revenue
FROM online_retail
ORDER BY Revenue DESC
LIMIT 10;


-- Identify extreme transactions

SELECT
    InvoiceNo,
    CustomerID,
    InvoiceDate,
    StockCode,
    Description,
    Quantity,
    UnitPrice,
    Revenue
FROM online_retail
WHERE Quantity > 10000
   OR Revenue > 50000
ORDER BY Revenue DESC;


-- Investigate customers affected by extreme transactions

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_invoices,
    COUNT(*) AS total_transactions,
    SUM(Revenue) AS total_revenue
FROM online_retail
WHERE CustomerID IN (12346, 16446)
GROUP BY CustomerID;


-- Detailed transaction history for Customer 16446

SELECT
    InvoiceNo,
    InvoiceDate,
    StockCode,
    Description,
    Quantity,
    UnitPrice,
    Revenue
FROM online_retail
WHERE CustomerID = 16446
ORDER BY InvoiceDate;


-- =========================================================
-- 3. RFM CALCULATION
-- Reference date: 2011-12-10
-- Extreme invoices excluded from RFM calculation
-- =========================================================

WITH rfm AS (
    SELECT
        CustomerID,

        DATEDIFF(
            '2011-12-10',
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(
            SUM(Revenue),
            2
        ) AS Monetary

    FROM online_retail

    WHERE InvoiceNo NOT IN ('541431', '581483')

    GROUP BY CustomerID
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary
FROM rfm
ORDER BY CustomerID
LIMIT 20;


-- =========================================================
-- 4. RFM SCORING
-- Quintile scoring using NTILE(5)
-- =========================================================

WITH rfm AS (
    SELECT
        CustomerID,

        DATEDIFF(
            '2011-12-10',
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(
            SUM(Revenue),
            2
        ) AS Monetary

    FROM online_retail

    WHERE InvoiceNo NOT IN ('541431', '581483')

    GROUP BY CustomerID
),

rfm_scored AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS R_Score,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS M_Score

    FROM rfm
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(
        R_Score,
        F_Score,
        M_Score
    ) AS RFM_Score

FROM rfm_scored

ORDER BY CustomerID
LIMIT 20;


-- =========================================================
-- 5. RFM SCORE DISTRIBUTION VALIDATION
-- =========================================================

WITH rfm AS (
    SELECT
        CustomerID,

        DATEDIFF(
            '2011-12-10',
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(
            SUM(Revenue),
            2
        ) AS Monetary

    FROM online_retail

    WHERE InvoiceNo NOT IN ('541431', '581483')

    GROUP BY CustomerID
),

rfm_scored AS (
    SELECT
        CustomerID,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS R_Score,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS M_Score

    FROM rfm
)

SELECT
    R_Score,
    COUNT(*) AS customer_count
FROM rfm_scored
GROUP BY R_Score
ORDER BY R_Score;


SELECT
    F_Score,
    COUNT(*) AS customer_count
FROM (
    WITH rfm AS (
        SELECT
            CustomerID,
            COUNT(DISTINCT InvoiceNo) AS Frequency
        FROM online_retail
        WHERE InvoiceNo NOT IN ('541431', '581483')
        GROUP BY CustomerID
    )

    SELECT
        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS F_Score
    FROM rfm
) AS scored
GROUP BY F_Score
ORDER BY F_Score;


SELECT
    M_Score,
    COUNT(*) AS customer_count
FROM (
    WITH rfm AS (
        SELECT
            CustomerID,
            ROUND(SUM(Revenue), 2) AS Monetary
        FROM online_retail
        WHERE InvoiceNo NOT IN ('541431', '581483')
        GROUP BY CustomerID
    )

    SELECT
        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS M_Score
    FROM rfm
) AS scored
GROUP BY M_Score
ORDER BY M_Score;


-- =========================================================
-- 6. CREATE FINAL RFM CUSTOMER TABLE
-- =========================================================

DROP TABLE IF EXISTS rfm_customer;


CREATE TABLE rfm_customer AS

WITH rfm AS (
    SELECT
        CustomerID,

        DATEDIFF(
            '2011-12-10',
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(
            SUM(Revenue),
            2
        ) AS Monetary

    FROM online_retail

    WHERE InvoiceNo NOT IN ('541431', '581483')

    GROUP BY CustomerID
),

rfm_scored AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS R_Score,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS M_Score

    FROM rfm
),

segmented AS (
    SELECT
        *,

        CASE

            WHEN R_Score >= 4
             AND F_Score >= 4
             AND M_Score >= 4
                THEN 'Champions'

            WHEN R_Score >= 3
             AND F_Score >= 3
             AND M_Score >= 3
                THEN 'Loyal Customers'

            WHEN R_Score >= 4
             AND F_Score = 3
             AND M_Score < 3
                THEN 'Potential Loyalists'

            WHEN R_Score >= 4
             AND F_Score <= 2
             AND M_Score >= 3
                THEN 'Promising'

            WHEN R_Score <= 2
             AND F_Score >= 3
                THEN 'At Risk'

            WHEN R_Score <= 2
             AND F_Score <= 2
                THEN 'Hibernating'

            ELSE 'Needs Attention'

        END AS Segment

    FROM rfm_scored
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,

    CONCAT(
        R_Score,
        F_Score,
        M_Score
    ) AS RFM_Score,

    Segment

FROM segmented;


-- =========================================================
-- 7. FINAL TABLE VALIDATION
-- =========================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT CustomerID) AS duplicate_customer_rows
FROM rfm_customer;


SELECT
    Segment,
    COUNT(*) AS customer_count
FROM rfm_customer
GROUP BY Segment
ORDER BY customer_count DESC;


-- Check that every customer is classified

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN Segment IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS classified_customers
FROM rfm_customer;