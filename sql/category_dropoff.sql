-- Drop-off rate by product category
SELECT
    SUBSTRING_INDEX(category_code, '.', 1) AS category,
    COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS buyers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END), 2) AS conversion_rate,
    ROUND(100.0 * (1 - COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                     / COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END)), 2) AS cart_abandonment_rate
FROM events
WHERE category_code IS NOT NULL
GROUP BY category
HAVING visitors > 1000
ORDER BY buyers DESC
LIMIT 10;

-- Drop-off by price range
SELECT
    CASE
        WHEN price < 20  THEN '1. Under $20'
        WHEN price < 50  THEN '2. $20-50'
        WHEN price < 100 THEN '3. $50-100'
        WHEN price < 200 THEN '4. $100-200'
        ELSE                   '5. $200+'
    END AS price_range,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS buyers,
    ROUND(100.0 * (1 - COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                     / COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END)), 2) AS abandonment_rate
FROM events
GROUP BY price_range
ORDER BY price_range;