-- SELECT R.*, T.zena, R.kolvo * T.zena FROM rashod R, tovar T WHERE R.tovar = T.tovar;

SELECT R.*, T.zena, R.kolvo * T.zena AS stoim FROM rashod R, tovar T WHERE R.tovar = T.tovar;