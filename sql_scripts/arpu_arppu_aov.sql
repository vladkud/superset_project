-- распаковываем массив значений, содержащих id купленных покупок,
-- чтобы найти общую сумму покупок

WITH unnested_products_cte AS (
SELECT
    -- здесь и далее именуем столбец как "date" исключительно по условиям техзадания
    creation_time::date AS date,
    order_id,
    UNNEST(product_ids) AS product_id
FROM
    orders t1
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
),
-- находим сумму покупок по каждой дате

order_prices_cte AS (
SELECT
    date,
    sum(price) AS daily_revenue
FROM
    unnested_products_cte
JOIN products
        USING (product_id)
GROUP BY
    date
),
-- находим число пользователей по дате,
-- исключая тех, что отменили свой заказ
-- используем NOT EXISTS вместо IN для ускорения запроса

paying_users_cte AS
(
SELECT
    time :: date AS date,
    count(DISTINCT user_id) AS paying_users,
    count(order_id) AS total_orders
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
GROUP BY
    time::date
),
-- считаем общее число пользователей

total_users AS
(
SELECT
    time::date AS date,
    COUNT(DISTINCT user_id) AS total_users
FROM
    user_actions
GROUP BY
    time::date
)
-- рассчитываем показатели средней выручки на пользователя (arpu),
-- средней выручки на платящего пользователя (arppu),
-- и среднего чека (aov)

SELECT
    date,
    round (daily_revenue / total_users::NUMERIC,
    2) AS arpu,
    round (daily_revenue / paying_users::NUMERIC,
    2) AS arppu,
    round (daily_revenue / total_orders::NUMERIC,
    2) AS aov
FROM
    order_prices_cte
JOIN paying_users_cte
        USING (date)
JOIN total_users
        USING (date)
