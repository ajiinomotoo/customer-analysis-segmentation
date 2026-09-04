USE customer_segmentation;


-- =========================================================
-- 1. SEGMENT PERFORMANCE
-- =========================================================

SELECT
    Segment,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM rfm_customer),
        2
    ) AS customer_percentage,

    ROUND(
        SUM(Monetary),
        2
    ) AS total_revenue,

    ROUND(
        SUM(Monetary) * 100.0 /
        (SELECT SUM(Monetary) FROM rfm_customer),
        2
    ) AS revenue_percentage,

    ROUND(
        AVG(Monetary),
        2
    ) AS avg_customer_value

FROM rfm_customer

GROUP BY Segment

ORDER BY total_revenue DESC;


-- =========================================================
-- 2. AT RISK & HIBERNATING PERFORMANCE
-- =========================================================

SELECT
    Segment,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM rfm_customer),
        2
    ) AS customer_percentage,

    ROUND(
        SUM(Monetary),
        2
    ) AS historical_revenue,

    ROUND(
        SUM(Monetary) * 100.0 /
        (SELECT SUM(Monetary) FROM rfm_customer),
        2
    ) AS revenue_percentage,

    ROUND(
        AVG(Monetary),
        2
    ) AS avg_customer_value

FROM rfm_customer

WHERE Segment IN (
    'At Risk',
    'Hibernating'
)

GROUP BY Segment

ORDER BY historical_revenue DESC;


-- =========================================================
-- 3. HIGH-VALUE AT RISK CUSTOMERS
-- =========================================================

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    RFM_Score,
    Segment

FROM rfm_customer

WHERE Segment = 'At Risk'

ORDER BY Monetary DESC

LIMIT 20;


-- =========================================================
-- 4. TOP 20 CUSTOMERS BY MONETARY VALUE
-- =========================================================

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    RFM_Score,
    Segment

FROM rfm_customer

ORDER BY Monetary DESC

LIMIT 20;


-- =========================================================
-- 5. SEGMENT RFM PROFILE
-- =========================================================

SELECT
    Segment,

    COUNT(*) AS customer_count,

    ROUND(
        AVG(Recency),
        1
    ) AS avg_recency,

    ROUND(
        AVG(Frequency),
        1
    ) AS avg_frequency,

    ROUND(
        AVG(Monetary),
        2
    ) AS avg_monetary,

    ROUND(
        AVG(R_Score),
        2
    ) AS avg_r_score,

    ROUND(
        AVG(F_Score),
        2
    ) AS avg_f_score,

    ROUND(
        AVG(M_Score),
        2
    ) AS avg_m_score

FROM rfm_customer

GROUP BY Segment

ORDER BY avg_recency ASC;


-- =========================================================
-- 6. REVENUE CONCENTRATION — TOP 10 CUSTOMERS
-- =========================================================

SELECT
    ROUND(
        SUM(Monetary),
        2
    ) AS top_10_revenue,

    ROUND(
        SUM(Monetary) /
        (SELECT SUM(Monetary) FROM rfm_customer)
        * 100,
        2
    ) AS top_10_revenue_percentage

FROM (
    SELECT
        Monetary

    FROM rfm_customer

    ORDER BY Monetary DESC

    LIMIT 10

) AS top_customers;


-- =========================================================
-- 7. RFM SCORE DISTRIBUTION
-- =========================================================

SELECT
    R_Score,
    COUNT(*) AS customer_count

FROM rfm_customer

GROUP BY R_Score

ORDER BY R_Score;


SELECT
    F_Score,
    COUNT(*) AS customer_count

FROM rfm_customer

GROUP BY F_Score

ORDER BY F_Score;


SELECT
    M_Score,
    COUNT(*) AS customer_count

FROM rfm_customer

GROUP BY M_Score

ORDER BY M_Score;


-- =========================================================
-- 8. SEGMENT RFM SCORE RANGE
-- =========================================================

SELECT
    Segment,

    MIN(R_Score) AS min_r_score,
    MAX(R_Score) AS max_r_score,

    MIN(F_Score) AS min_f_score,
    MAX(F_Score) AS max_f_score,

    MIN(M_Score) AS min_m_score,
    MAX(M_Score) AS max_m_score

FROM rfm_customer

GROUP BY Segment

ORDER BY Segment;