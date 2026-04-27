-- SELECT rashod.*, tovar.zena FROM rashod, tovar WHERE rashod.tovar = tovar.tovar AND tovar.zena > 80;

-- SELECT R.*, P.gorod FROM rashod R, pokupateli P WHERE R.pokup = P.pokup;

SELECT DISTINCT tovar FROM rashod;