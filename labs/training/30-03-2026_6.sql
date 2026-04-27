-- Показать даты продаж товаров, в которых количество проданного товара было не меньше 1000 единиц. 
-- В результирующий НД включить только те группы, по которым количество таких продаж больше 1
-- SELECT data_rash, COUNT(*) AS count FROM rashod WHERE kolvo >= 1000 GROUP BY data_rash HAVING COUNT(*) > 1;

SELECT * FROM rashod WHERE kolvo = 3000 UNION SELECT * FROM rashod WHERE pokup = 'Лира_ООО';