-- SELECT R.*, T.zena FROM rashod R, tovar T WHERE R.tovar = T.tovar AND (R.kolvo <= 30 OR R.kolvo >= 3000) AND R.pokup IS NOT NULL ORDER BY R.kolvo;

SELECT * FROM rashod WHERE pokup IS NULL;