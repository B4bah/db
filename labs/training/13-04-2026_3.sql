-- Поменять цену товара, который продаётся в банке, на 30%

UPDATE tovar SET
zena = zena * 1.30
WHERE ed_izm = 'банка';