-- SELECT rashod.*, tovar.zena FROM rashod, tovar WHERE rashod.tovar = tovar.tovar;

SELECT rashod.*, pokupateli.gorod FROM rashod, pokupateli WHERE rashod.pokup = pokupateli.pokup;