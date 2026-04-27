-- 1.1
-- SELECT ART.artist_id, ART.name 
-- FROM artist ART, (
-- 	SELECT artist_id
-- 	FROM painting
-- 	WHERE year > 1800 AND type = 'подлинник' AND price =
-- 	(SELECT MIN(price) FROM painting WHERE type = 'подлинник')) PAINT
-- 	WHERE PAINT.artist_id = ART.artist_id;

-- 1.2
-- SELECT ART.artist_id, ART.name, sum_price::NUMERIC
-- FROM artist ART, (
-- 	SELECT artist_id, SUM(price) as sum_price
-- 	FROM painting
-- 	WHERE genre LIKE('%живопись%')
-- 	GROUP BY artist_id) PAINT
-- 	WHERE ART.artist_id = PAINT.artist_id;

-- 1.3
SELECT PAINT.painting_id, OWN.pass_num, OWN.name
FROM (
	SELECT ownerpass_num, painting_id
	FROM painting
	WHERE price::NUMERIC >
	(SELECT AVG(price::NUMERIC)
	 FROM painting)) PAINT LEFT JOIN owner OWN
	ON OWN.pass_num = PAINT.ownerpass_num;