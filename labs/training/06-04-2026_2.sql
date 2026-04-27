-- Определить покупателя, у которого средняя покупка больше средней покупки других покупателей, и среднее количество покупок этого покупателя
-- SELECT r1.pokup, AVG(r1.kolvo) as average
-- FROM rashod r1
-- GROUP BY r1.pokup
-- HAVING AVG(r1.kolvo) >=ALL
-- (SELECT AVG(r2.kolvo)
--  FROM rashod r2
--  GROUP BY r2.pokup);
 
-- Определить реквизиты покупателя, который приобрёл наименьшее количество товаров
-- SELECT P.* FROM pokupateli P
-- WHERE P.pokup =
-- (SELECT RR.pokup FROM rashod RR GROUP BY pokup
--  HAVING SUM(RR.kolvo) >= )

SELECT rashod.*, tovar.zena FROM rashod JOIN tovar ON rashod.tovar = tovar.tovar;

SELECT P.pokup, P.gorod, R.data_rash, R.tovar, R.kolvo
FROM pokupateli P FULL JOIN rashod R ON R.pokup = P.pokup;