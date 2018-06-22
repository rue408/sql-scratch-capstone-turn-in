1. How many campaigns and sources does CoolTShirts use? 

SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Source'
FROM page_visits;


1a. Which source is used for each campaign?	 

SELECT DISTINCT utm_campaign AS 'Campaign', utm_source AS 'Source'
FROM page_visits;


2. What pages are on the CoolTShirts website?

SELECT DISTINCT page_name 
FROM page_visits;


3. How many first touches is each campaign responsible for?

WITH first_touch AS (
  SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2	
ORDER BY 3 DESC;

4. How many last touches is each campaign responsible for?

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

5. How many visitors make a purchase?

SELECT COUNT(*)
FROM page_visits
WHERE page_name = '4 - purchase';

6. How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;