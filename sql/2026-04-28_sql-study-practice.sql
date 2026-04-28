-- 2026-04-28 SQL Study Practice
-- Topic: JOIN / WHERE / GROUP BY / COUNT / COUNT DISTINCT
-- BigQuery 기준

-- 문제 1. 트레이너가 보유한 포켓몬 종류별 수 계산
SELECT
  p.kor_name,
  COUNT(tp.id) AS pokemon_cnt
FROM `basic.trainer_pokemon` AS tp
LEFT JOIN `basic.pokemon` AS p
  ON tp.pokemon_id = p.id
WHERE tp.status IN ('Active', 'Training')
GROUP BY p.kor_name
ORDER BY pokemon_cnt DESC;

-- 문제 2. 각 트레이너가 가진 Grass 타입 포켓몬 수 계산
SELECT
  tp.trainer_id,
  COUNT(tp.pokemon_id) AS grass_pokemon_cnt
FROM `basic.trainer_pokemon` AS tp
LEFT JOIN `basic.pokemon` AS p
  ON tp.pokemon_id = p.id
WHERE p.type1 = 'Grass'
GROUP BY tp.trainer_id
ORDER BY tp.trainer_id;

-- 문제 3. 자신의 고향에서 포켓몬을 포획한 트레이너 수 계산
SELECT
  COUNT(DISTINCT tp.trainer_id) AS trainer_cnt
FROM `basic.trainer_pokemon` AS tp
LEFT JOIN `basic.trainer` AS t
  ON tp.trainer_id = t.id
WHERE t.hometown = tp.location;

-- 문제 4. Master 등급 트레이너들이 가장 많이 보유한 포켓몬 타입 계산
SELECT
  p.type1,
  COUNT(tp.pokemon_id) AS pokemon_count
FROM `basic.trainer` AS t
LEFT JOIN `basic.trainer_pokemon` AS tp
  ON t.id = tp.trainer_id
LEFT JOIN `basic.pokemon` AS p
  ON tp.pokemon_id = p.id
WHERE t.achievement_level = 'Master'
  AND tp.status IN ('Active', 'Training')
GROUP BY p.type1
ORDER BY pokemon_count DESC;

-- 문제 5. INCHEON 출신 트레이너들이 보유한 1세대, 2세대 포켓몬 수 계산
SELECT
  tp.trainer_id,
  p.generation,
  COUNT(*) AS cnt
FROM `basic.trainer_pokemon` AS tp
LEFT JOIN `basic.trainer` AS t
  ON tp.trainer_id = t.id
LEFT JOIN `basic.pokemon` AS p
  ON tp.pokemon_id = p.id
WHERE t.hometown = 'Incheon'
  AND p.generation IN (1, 2)
GROUP BY tp.trainer_id, p.generation
ORDER BY tp.trainer_id;