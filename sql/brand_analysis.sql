-- Brand-level cart abandonment
SELECT
    brand,
    COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS buyers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END), 2) AS conversion_rate,
    ROUND(100.0 * (1 - COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                     / COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END)), 2) AS abandonment_rate
FROM events
WHERE brand IS NOT NULL
GROUP BY brand
HAVING cart_users > 2000
ORDER BY cart_users DESC
LIMIT 15;

-- User segmentation summary
SELECT
    CASE
        WHEN did_purchase = 1 AND purchase_count > 1 THEN 'repeat_buyer'
        WHEN did_purchase = 1                        THEN 'buyer'
        WHEN did_cart = 1                            THEN 'considerer'
        ELSE                                              'browser'
    END AS segment,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct
FROM user_summary
GROUP BY segment
ORDER BY user_count DESC;