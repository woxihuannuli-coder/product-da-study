-- 목표: 가입 후 30일 안에 첫 구매한 유저 중, 첫 구매 후 30일 안에 두 번째 구매를 하지 않은 유저를 CRM 후보로 분류

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
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON AP.user_id = o.user_id
  WHERE o.order_id IS NOT NULL
    AND DATE(o.created_at) > AP.first_purchase_date
    AND DATE(o.created_at) <= DATE_ADD(AP.first_purchase_date, INTERVAL 30 DAY)
)

SELECT
  AP.user_id,
  AP.signup_date,
  AP.first_purchase_date,
  '재구매_유도_대상' AS crm_segment
FROM ADD_PURCHASE AS AP
LEFT JOIN second_purchase AS SP
  ON AP.user_id = SP.user_id
WHERE SP.user_id IS NULL
ORDER BY AP.first_purchase_date;