-- 목적:
-- 재구매 분석이 가능한지 먼저 확인한다.
-- users / orders 테이블의 기본 규모, 주문 날짜 범위, 핵심 컬럼 null 여부를 점검한다.

-- 1) 전체 회원 수
SELECT
  COUNT(DISTINCT id) AS user_cnt
FROM `bigquery-public-data.thelook_ecommerce.users`;

-- 2) 한 번이라도 주문한 회원 수
SELECT
  COUNT(DISTINCT user_id) AS ordered_user_cnt
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- 3) 전체 주문 수
SELECT
  COUNT(DISTINCT order_id) AS order_cnt
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- 4) 주문 날짜 범위 확인
SELECT
  MIN(created_at) AS min_order_date,
  MAX(created_at) AS max_order_date
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- 5) orders 핵심 컬럼 null 여부 확인
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(order_id IS NULL) AS null_order_id,
  COUNTIF(user_id IS NULL) AS null_user_id,
  COUNTIF(created_at IS NULL) AS null_created_at
FROM `bigquery-public-data.thelook_ecommerce.orders`;
