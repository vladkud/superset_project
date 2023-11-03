SELECT
    count(DISTINCT user_id) AS paying_users,
    count(DISTINCT order_id) AS total_orders
FROM
    user_actions t1
WHERE
    NOT EXISTS (
    SELECT
        order_id
    FROM
        user_actions t2
    WHERE
        ACTION = 'cancel_order'
        AND t1.order_id = t2.order_id
)