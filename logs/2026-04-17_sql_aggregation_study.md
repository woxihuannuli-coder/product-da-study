가정 테이블:

- `users(user_id, gender, signup_date, age)`
- `events(event_id, user_id, event_name, event_date)`
- `orders(order_id, user_id, category, order_amount, order_date)`


1. 성별 별 유저 수 (⭕️)

[내 답안]
SELECT gender, COUNT(*)
FROM users
GROUP BY gender;



2. 20대 성별별 유저 수 (⭕️)

[내 답안]
SELECT gender, COUNT(*)
FROM users
WHERE age BETWEEN 20 and 29
GROUP BY gender;



3. 이벤트별 유저 수 (❌)

[내 답안]
SELECT event_name, count(user_id)
FROM events
GROUP BY event_name;
 

[답안]
SELECT event_name, COUNT(DISTINCT user_id)
FROM events
GROUP BY event_name;

[왜 틀렸는지]
- 문제에서 원하는 것은 이벤트별 유저 수인데, COUNT(user_id)는 같은 유저가 같은 이벤트를 여러 번 해도 중복으로 셀 수 있다.
- 이벤트 로그 테이블에서는 한 사용자가 같은 이벤트를 여러 번 발생시킬 수 있으므로, 유저 수를 보려면 중복 제거가 필요하다.
- event_name으로 그룹화한 다음 count를 하기 때문에, count(DISTINCT user_id)로 계산하는 것이 맞다. 

[배운 것]
이벤트별 유저 수를 구할 때는 보통 COUNT(DISTINCT user_id)를 쓴다.
이벤트별 발생 건수를 구할 때는 COUNT(*)를 쓴다.


4. 이벤트별 유저 수 많은 순 정렬 (⭕️)

SELECT event_name, count(user_id)
FROM events
GROUP BY event_name
ORDER BY count(user_id), DESC;


5. 카테고리별 평균 주문금액

SELECT category, AVG(order_amount) AS avg_am
FROM orders
GROUP BY category;



6. 카테고리별 최대 주문금액 (⭕️)
   
SELECT category, MAX(order_amount) AS MAX_am
FROM orders
GROUP BY category;

