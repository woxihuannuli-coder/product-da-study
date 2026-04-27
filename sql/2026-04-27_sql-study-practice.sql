포켓몬 데이터 분석 SQL 문제 풀이

주요 학습 내용
CASE WHEN: 다중 조건에 따른 값 분류

IF: 단일 조건에 따른 이진 분류

EXTRACT: 날짜 데이터에서 특정 연도 추출

Subquery & GROUP BY: 분류된 값을 기준으로 통계량 산출


1. 타입 및 능력치 분류
예시. Rock & Ground 타입 통합 분류
#쿼리를 작성하는 목표, 확인할 지표: 특정 타입(Rock, Ground)을 하나로 통합하여 새로운 타입 컬럼 생성

#쿼리 계산 방법: CASE WHEN

#데이터 기간: x

#사용할 테이블: pokemon

#JOIN key: x

#데이터 특징: type1, type2 두 가지 컬럼을 모두 고려해야 함

SQL
SELECT
  *,
  CASE
    WHEN (type1 IN ('Rock', 'Ground')) OR (type2 IN ('Rock', 'Ground')) THEN "Rock&Ground"
    ELSE type1
  END AS new_type1
FROM `basic.pokemon`
WHERE type2 IN ('Rock', 'Ground');



문제 2. 스피드 기준 속도 카테고리 생성
#쿼리를 작성하는 목표, 확인할 지표: 포켓몬의 스피드 수치에 따른 속도감 분류

#쿼리 계산 방법: IF문

#데이터 기간: x

#사용할 테이블: pokemon

#JOIN key: x

#데이터 특징: 70이라는 단일 임계치를 기준으로 이진 분류

SQL
SELECT
  *,
  IF(speed >= 70, "빠름", "느림") AS speed_category
FROM `basic.pokemon`;



문제 3. 주요 타입 한국어 번역 및 기타 분류
#쿼리를 작성하는 목표, 확인할 지표: 주요 3개 타입(Water, Fire, Electric)의 한글화 및 나머지 그룹화

#쿼리 계산 방법: CASE WHEN

#데이터 기간: x

#사용할 테이블: pokemon

#JOIN key: x

#데이터 특징: 지정되지 않은 타입은 모두 '기타'로 처리

SQL
SELECT
  id,
  kor_name,
  type1,
  CASE
    WHEN type1 = 'Water' THEN '물'
    WHEN type1 = 'Fire' THEN '불'
    WHEN type1 = 'Electric' THEN '전기'
    ELSE "기타"
  END AS type_korean
FROM `basic.pokemon`;




문제 4. 총점(Total) 기반 등급 분류
#쿼리를 작성하는 목표, 확인할 지표: 포켓몬 총점에 따른 3단계(Low, Medium, High) 성능 분류

#쿼리 계산 방법: CASE WHEN (BETWEEN 활용)

#데이터 기간: x

#사용할 테이블: pokemon

#JOIN key: x

#데이터 특징: 범위를 설정할 때 큰 값부터 작성하거나 경계값을 명확히 구분해야 함

SQL
SELECT
  id,
  kor_name,
  CASE
    WHEN total >= 501 THEN 'High'
    WHEN total BETWEEN 301 AND 500 THEN 'Medium'
    ELSE 'Low'
  END AS total_val
FROM `basic.pokemon`;




문제 5. 배지 개수별 트레이너 수준 집계
#쿼리를 작성하는 목표, 확인할 지표: 트레이너의 배지 보유량에 따른 숙련도별 인원수 파악

#쿼리 계산 방법: 서브쿼리를 활용한 CASE WHEN 및 GROUP BY

#데이터 기간: x

#사용할 테이블: trainer

#JOIN key: x

#데이터 특징: 분류된 값을 기준으로 다시 한번 집계가 필요함

SQL
SELECT
  badge_val,
  COUNT(badge_val) AS trainer_count
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
ORDER BY badge_val DESC;




문제 6. 포획 날짜 기준 신규/기존 데이터 분류
#쿼리를 작성하는 목표, 확인할 지표: 2023년 1월 1일 이후 포획 여부에 따른 데이터 신선도 분류

#쿼리 계산 방법: IF 및 날짜 비교

#데이터 기간: 2023-01-01 기준

#사용할 테이블: trainer_pokemon

#JOIN key: x

#데이터 특징: 날짜 데이터는 문자열('2023-01-01')과 직접 비교가 가능함

SQL
SELECT
  trainer_id,
  catch_date,
  IF(catch_date >= '2023-01-01', 'Recent', 'Old') AS catch_level
FROM `basic.trainer_pokemon`;