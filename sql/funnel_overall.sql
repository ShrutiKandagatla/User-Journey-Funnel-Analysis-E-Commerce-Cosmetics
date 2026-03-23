-- Overall funnel conversion rates
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS buyers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END), 2) AS view_to_cart_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END), 2) AS cart_to_purchase_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END), 2) AS overall_conversion_pct
FROM events;

-- Monthly funnel trend
SELECT
    month,
    COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'cart'     THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS buyers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                / COUNT(DISTINCT CASE WHEN event_type = 'view'     THEN user_id END), 2) AS conversion_rate
FROM events
GROUP BY month
ORDER BY month;