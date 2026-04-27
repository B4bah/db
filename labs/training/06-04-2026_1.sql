-- Вывести список покупателей, которые хоть раз покупали товар
-- SELECT P.pokup FROM pokupateli P
-- WHERE EXISTS
-- (SELECT R.pokup FROM rashod R
--  WHERE R.pokup = P.pokup)
 
-- Определим все факты продаж товара, в которых количество единиц проданного товара превышало среднее значение
-- SELECT * FROM rashod R
-- WHERE R.kolvo > All
-- (SELECT AVG(R.kolvo) FROM rashod R GROUP BY R.pokup)

-- Определим все факты продаж товаров, в которых количество единиц проданного товара превышало среднее значение хотя бы для одного товара
SELECT * FROM rashod R
WHERE R.kolvo > SOME
(SELECT AVG(R.kolvo) FROM rashod R GROUP BY R.pokup)