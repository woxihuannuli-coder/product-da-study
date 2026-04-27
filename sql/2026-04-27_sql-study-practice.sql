-- 2026-04-27 SQL Study Practice
-- Topic: CASE WHEN / IF / IN / BETWEEN / GROUP BY
-- BigQuery 기준

-- 문제 1. Rock & Ground 타입 통합 분류
SELECT
  *,
  CASE
    WHEN type1 IN ('Rock', 'Ground') OR type2 IN ('Rock', 'Ground') THEN 'Rock&Ground'
    ELSE type1
  END AS new_type1
FROM `basic.pokemon`;


-- 문제 2. 스피드 기준 속도 카테고리 생성
SELECT
  *,
  IF(speed >= 70, '빠름', '느림') AS speed_category
FROM `basic.pokemon`;


-- 문제 3. 주요 타입 한국어 번역 및 기타 분류
SELECT
  id,
  kor_name,
  type1,
  CASE
    WHEN type1 = 'Water' THEN '물'
    WHEN type1 = 'Fire' THEN '불'
    WHEN type1 = 'Electric' THEN '전기'
    ELSE '기타'
  END AS type_korean
FROM `basic.pokemon`;


-- 문제 4. total 기반 등급 분류
SELECT
  id,
  kor_name,
  total,
  CASE
    WHEN total >= 501 THEN 'High'
    WHEN total BETWEEN 301 AND 500 THEN 'Medium'
    ELSE 'Low'
  END AS total_val
FROM `basic.pokemon`;


--문제 5. 배지 개수별 트레이너 수준 집계
SELECT
  badge_val,
  COUNT(*) AS trainer_count
FROM (
  SELECT
    id,
    name,
    badge_count,
    CASE
      WHEN badge_count >= 9 THEN 'Advanced'
      WHEN badge_count BETWEEN 6 AND 8 THEN 'Intermediate'
      ELSE 'Beginner'
    END AS badge_val
  FROM `basic.trainer`
)
GROUP BY badge_val
ORDER BY trainer_count DESC;


-- 문제 6. 포획 날짜 기준 신규/기존 데이터 분류
SELECT
  trainer_id,
  catch_date,
  IF(catch_date >= '2023-01-01', 'Recent', 'Old') AS catch_level
FROM `basic.trainer_pokemon`;