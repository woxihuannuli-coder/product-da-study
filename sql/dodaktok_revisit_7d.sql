-- 가입 후 7일 재방문율
-- 가정 테이블:
-- users(user_id, signup_date, is_test_user)
-- events(user_id, event_name, event_time)

WITH april_users AS (
  SELECT
    user_id,
    signup_date
  FROM users
  WHERE signup_date >= '2026-04-01'
    AND signup_date <= '2026-04-30'
    AND signup_date <= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND is_test_user = FALSE
),

revisit_users AS (
  SELECT
    u.user_id
  FROM april_users u
  JOIN events e
    ON u.user_id = e.user_id
  WHERE e.event_name = 'app_opened'
    AND DATE(e.event_time) BETWEEN u.signup_date AND DATE_ADD(u.signup_date, INTERVAL 6 DAY)
  GROUP BY u.user_id
  HAVING COUNT(DISTINCT DATE(e.event_time)) >= 3
)

SELECT
  (SELECT COUNT(*) FROM april_users) AS april_user_cnt,
  (SELECT COUNT(*) FROM revisit_users) AS revisit_user_cnt,
  SAFE_DIVIDE(
    (SELECT COUNT(*) FROM revisit_users),
    (SELECT COUNT(*) FROM april_users)
  ) AS revisit_rate_7d;