-- Вычислить все агрегатные функции для таблицы товар
-- SELECT SUM(R.kolvo * T.zena) as total_price FROM rashod R, tovar T WHERE (R.tovar = T.tovar) AND (R.data_rash = '2020-01-20');

-- SELECT SUM(T.zena) as total_price, ROUND(AVG(T.zena), 2) as avg_price, MIN(T.zena) as min_price, MAX(T.zena) as max_price, COUNT(*) FROM tovar T;

-- 
SELECT tovar, SUM(kolvo) FROM rashod WHERE rashod.data_rash = '2020-01-20' GROUP BY tovar;