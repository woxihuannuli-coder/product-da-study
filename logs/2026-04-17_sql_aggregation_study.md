# 2026-04-17 SQL 집계 기초 학습일지

주제: GROUP BY 기반 집계 연습

테이블
- users(user_id, gender, signup_date, age)
- events(event_id, user_id, event_name, event_date)
- orders(order_id, user_id, category, order_amount, order_date)

---

## 1. 성별별 유저 수 (O)

```sql
SELECT gender, COUNT(*)
FROM users
GROUP BY gender;
```

---

## 2. 20대 성별별 유저 수 (O)

```sql
SELECT gender, COUNT(*)
FROM users
WHERE age BETWEEN 20 AND 29
GROUP BY gender;
```

---

## 3. 이벤트별 유저 수 (X)

내 답안
```sql
SELECT event_name, COUNT(user_id)
FROM events
GROUP BY event_name;
```

정답
```sql
SELECT event_name, COUNT(DISTINCT user_id)
FROM events
GROUP BY event_name;
```

왜 틀렸는지
- COUNT(user_id)는 같은 유저가 같은 이벤트를 여러 번 해도 중복으로 셈
- 이벤트 로그에서는 한 유저가 같은 이벤트를 여러 번 발생시킬 수 있으므로 중복 제거 필요

배운 것
- 이벤트별 유저 수 → COUNT(DISTINCT user_id)
- 이벤트별 발생 건수 → COUNT(*)

---

## 4. 이벤트별 유저 수 많은 순 정렬 (O)

```sql
SELECT event_name, COUNT(DISTINCT user_id) AS user_count
FROM events
GROUP BY event_name
ORDER BY user_count DESC;
```

---

## 5. 카테고리별 평균 주문금액 (O)

```sql
SELECT category, AVG(order_amount) AS avg_amount
FROM orders
GROUP BY category;
```

---

## 6. 카테고리별 최대 주문금액 (O)

```sql
SELECT category, MAX(order_amount) AS max_amount
FROM orders
GROUP BY category;
```
