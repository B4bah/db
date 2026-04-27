SELECT R.data_rash, R.tovar, (R.kolvo * T.zena) AS stoim FROM rashod R, tovar T 
WHERE R.tovar = T.tovar AND (R.kolvo * T.zena) > 100000
ORDER BY R.data_rash