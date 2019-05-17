 //Code to answer to "What columns does the table have?"//

 SELECT * 
 FROM survey
 LIMIT 10;

//code to find answer to "What is the number of responses for each question"//
 SELECT *, COUNT(response)
 FROM survey
 GROUP BY question;

 // Find answer to how many columns are in the quiz, home_try_on, and purchase table//

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT * 
FROM purchase
LIMIT 5;

//Left join to create temporary table //

SELECT DISTINCT q.user_id, 
	CASE
  	WHEN  h.user_id IS NOT NULL THEN 'true'
    WHEN h.user_id IS NULL then 'false'
  END AS 'is_home_try_on',  
  h.number_of_pairs,
  CASE
  	WHEN  p.user_id IS NOT NULL THEN 'true'
    WHEN p.user_id IS NULL THEN 'false'
  END AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id
LIMIT 10;

//conversion comparisons//
WITH funnel AS (SELECT DISTINCT q.user_id, 
	h.user_id IS NOT NULL AS 'is_home_try_on',
    h.number_of_pairs, 
    p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id)
SELECT COUNT(user_id) AS 'quiz_takers', 
    SUM(is_home_try_on) AS 'try_ons', 
    SUM(is_purchase) AS 'successful_purchases', 
    1.0 * SUM(is_home_try_on) / COUNT (user_id), 
    1.0 * SUM(is_purchase) / SUM(is_home_try_on)
FROM funnel;

//The most popular style//
SELECT *, COUNT(style)
FROM quiz
GROUP BY style
ORDER BY COUNT(style) DESC;

//the most purchased style//
SELECT *, COUNT(style)
FROM purchase
GROUP BY style
ORDER BY COUNT(style) DESC;

//users that chose the style on the quiz and actually made a purchase for that style//
SELECT quiz.user_id, quiz.style, COUNT(quiz.style),COUNT(purchase.style)
FROM quiz
LEFT JOIN purchase
ON purchase.user_id = quiz.user_id
GROUP BY quiz.style
ORDER BY COUNT (purchase.style) DESC;

//the most popular shape//
SELECT *, COUNT(shape)
FROM quiz
GROUP BY shape
ORDER BY COUNT(shape) DESC;

//the most purchased eyewear//
SELECT *, COUNT(model_name)
FROM purchase
GROUP BY model_name
ORDER BY COUNT(model_name) DESC;
