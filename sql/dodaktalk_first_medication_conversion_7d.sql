--  가입 후 7일 이내 첫 복약 기록 전환율
-- 가정 테이블:
-- users(user_id, signup_date, is_test_user)
-- events(user_id, event_name, event_time)


SELECT
  total.total_users,
  converted.converted_users,
  ROUND(converted.converted_users / total.total_users * 100, 2) AS first_medication_conversion_rate
FROM (
  SELECT
    COUNT(DISTINCT user_id) AS total_users
  FROM users
  WHERE signup_date BETWEEN '2026-04-01' AND '2026-04-30'
    AND signup_date <= DATE_SUB(CURRENT_DATE('Asia/Seoul'), INTERVAL 7 DAY)
) AS total
CROSS JOIN (
  SELECT
    COUNT(DISTINCT R.user_id) AS converted_users
  FROM (
    SELECT
      user_id,
      signup_date
    FROM users
    WHERE signup_date BETWEEN '2026-04-01' AND '2026-04-30'
      AND signup_date <= DATE_SUB(CURRENT_DATE('Asia/Seoul'), INTERVAL 7 DAY)
  ) AS R
  JOIN events AS E
    ON R.user_id = E.user_id
  WHERE E.event_name = 'dose_checked'
    AND DATE(E.event_time, 'Asia/Seoul') >= R.signup_date
    AND DATE(E.event_time, 'Asia/Seoul') < DATE_ADD(R.signup_date, INTERVAL 7 DAY)
) AS converted;