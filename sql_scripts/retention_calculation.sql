-- находим даты первой покупки каждого из пользователей
-- для дальнейшего разбития по когортам;

WITH min_date_cte AS (
SELECT
    user_id,
    time::date,
    min(time::date) OVER (PARTITION BY user_id) AS start_date
FROM
    user_actions

),
-- находим число уникальных пользователей в каждую из дат,
-- учитываем только одно значение даты, если в день первой покупки
-- совершено более одной покупки;
-- также формируем когорты по месяцам и времени от первой покупки

distinct_users_cte AS (
SELECT
    count(DISTINCT user_id) AS uid_count,
    date_trunc('month',
    start_date)::date AS start_month,
    start_date,
    time - start_date AS day_number
FROM
    min_date_cte
GROUP BY
    start_date,
    start_month,
    day_number
)
-- рассчитываем показатель удержания пользователей

SELECT
    start_month,
    start_date,
    day_number,
    round(
        uid_count::decimal
        /
        max(uid_count) OVER (PARTITION BY start_date)
    ,
    2) AS retention
FROM
    distinct_users_cte
