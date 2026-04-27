-- Вычислить общее количество каждого из проданных товаров
SELECT R.tovar, SUM(R.kolvo * T.zena) as total FROM rashod R, tovar T WHERE R.tovar = T.tovar GROUP BY R.tovar;

-- Вычислить общую цену по каждому проданному товару на каждую дату
-- SELECT R.tovar, R.data_rash, SUM(R.kolvo * T.zena) as total FROM rashod R, tovar T WHERE R.tovar = T.tovar GROUP BY R.tovar, R.data_rash;