4월 24일 시계열 SQL 공부: 최종 정답지 (KST 기준)


주요 함수: DATETIME, DATE, DATETIME_TRUNC, EXTRACT

1. 기본 변환 및 추출
문제 1. event_time을 KST 기준 DATETIME으로 변환

SQL
SELECT
  user_id,
  event_name,
  event_time,
  DATETIME(event_time, 'Asia/Seoul') AS event_datetime_kst
FROM events;

문제 2. KST 기준 YYYY-MM-DD 날짜 추출

SQL
SELECT
  user_id,
  event_name,
  DATE(DATETIME(event_time, 'Asia/Seoul')) AS event_date_kst
FROM events;

문제 3. KST 기준 시간(0~23시) 추출

SQL
SELECT
  user_id,
  event_name,
  EXTRACT(HOUR FROM DATETIME(event_time, 'Asia/Seoul')) AS event_hour_kst
FROM events;


문제 4. 날짜별 이벤트 수 집계

SQL
SELECT
  DATE(event_time, 'Asia/Seoul') AS event_date_kst,
  COUNT(*) AS event_cnt
FROM events
GROUP BY 1
ORDER BY event_date_kst;


문제 5. 시간대별 이벤트 수 집계 (Hour 단위)

SQL
SELECT
  DATETIME_TRUNC(DATETIME(event_time, 'Asia/Seoul'), HOUR) AS event_hour_kst,
  COUNT(*) AS event_cnt
FROM events
GROUP BY 1
ORDER BY event_hour_kst;


문제 6. 이벤트명별 총 이벤트 수 집계

SQL
SELECT
  event_name,
  COUNT(*) AS event_cnt
FROM events
GROUP BY event_name
ORDER BY event_cnt DESC;


문제 7. 날짜별 고유 사용자 수(DAU) 집계

SQL
SELECT
  DATE(event_time, 'Asia/Seoul') AS event_date_kst,
  COUNT(DISTINCT user_id) AS daily_unique_users
FROM events
GROUP BY 1
ORDER BY event_date_kst;


문제 8. 특정 이벤트('dose_checked') 데이터 필터링

SQL
SELECT
  user_id,
  event_name,
  DATETIME(event_time, 'Asia/Seoul') AS event_datetime_kst
FROM events
WHERE event_name = 'dose_checked';


문제 9. 날짜별 특정 이벤트('dose_checked') 수 집계

SQL
SELECT
  DATE(event_time, 'Asia/Seoul') AS event_date_kst,
  COUNT(*) AS dose_check_cnt
FROM events
WHERE event_name = 'dose_checked'
GROUP BY 1
ORDER BY event_date_kst;


문제 10. 사용자별 총 활동 수 집계

SQL
SELECT
  user_id,
  COUNT(*) AS total_event_cnt
FROM events
GROUP BY user_id
ORDER BY total_event_cnt DESC;