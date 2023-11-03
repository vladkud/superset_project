--  в подзапросе находим время первой покупки пользователя
--  используем оконную функцию с условием, чтобы избежать
--  группировок и ускорить запрос.
--  нарастающий итог от суммы уникальных пользователей в каждый день регистрации
--  будет являться суммой всех пользователей сервиса на конкретный день

SELECT
    DISTINCT time,
    count(user_id) OVER (PARTITION BY time) AS new_users,
    count(user_id) OVER (ORDER BY time) AS total_users
FROM
    (
    SELECT
        time::date,
        user_id,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY time ASC) AS action_rank
    FROM
        user_actions
    ORDER BY
        time ASC
) t1
WHERE
    action_rank = 1
