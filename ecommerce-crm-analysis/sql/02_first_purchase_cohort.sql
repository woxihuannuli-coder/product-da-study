-- 목표: 유저별 첫 구매일을 구하고, 가입 후 30일 안에 첫 구매한 유저만 남긴 뒤, 첫 구매 월(cohort_month) 기준으로 코호트를 만든다.

-- 02_first_purchase_cohort.sql
-- 가입 후 30일 안에 첫 구매한 유저를 정의한다.

WITH first_purchase AS (
  SELECT
    user_id,
    MIN(DATE(created_at)) AS first_purchase_date
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE order_id IS NOT NULL
    AND user_id IS NOT NULL
  GROUP BY user_id
),

ADD_PURCHASE AS (
  SELECT
    f.user_id,
    DATE(u.created_at) AS signup_date,
    f.first_purchase_date
  FROM first_purchase AS f
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` AS u
    ON f.user_id = u.id
  WHERE f.first_purchase_date >= DATE(u.created_at)
    AND f.first_purchase_date <= DATE_ADD(DATE(u.created_at), INTERVAL 30 DAY)
)

SELECT
  user_id,
  signup_date,
  first_purchase_date,
  DATE_TRUNC(first_purchase_date, MONTH) AS cohort_month
FROM ADD_PURCHASE
ORDER BY first_purchase_date;