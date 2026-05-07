-- 목표:
-- 가입 후 30일 안에 첫 구매한 유저를 대상으로, 첫 구매 후 30일 안에 두 번째 구매를 한 유저 수와 30일 재구매율을 계산한다.

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
),

second_purchase AS (
  SELECT DISTINCT
    AP.user_id
  FROM ADD_PURCHASE AS AP
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` AS O
    ON O.user_id = AP.user_id
  WHERE O.order_id IS NOT NULL
    AND DATE(O.created_at) > AP.first_purchase_date
    AND DATE(O.created_at) <= DATE_ADD(AP.first_purchase_date, INTERVAL 30 DAY)
)

SELECT
  (SELECT COUNT(*) FROM ADD_PURCHASE) AS first_user,
  (SELECT COUNT(*) FROM second_purchase) AS second_user,
  ROUND(
    SAFE_DIVIDE(
      (SELECT COUNT(*) FROM second_purchase),
      (SELECT COUNT(*) FROM ADD_PURCHASE)
    ) * 100,
    2
  ) AS repeat_purchase_rate_pct;