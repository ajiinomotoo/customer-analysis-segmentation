USE customer_segmentation;


-- =========================================================
-- POWER BI DATASET
-- =========================================================

CREATE OR REPLACE VIEW rfm_customer_powerbi AS

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    RFM_Score,
    Segment,

    CASE

        WHEN Segment = 'At Risk'
             AND Monetary >= 10000
            THEN 'High Priority'

        WHEN Segment IN (
            'At Risk',
            'Hibernating'
        )
            THEN 'Medium Priority'

        ELSE 'Low Priority'

    END AS Retention_Priority

FROM rfm_customer;