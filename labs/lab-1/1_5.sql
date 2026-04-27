SELECT E.tabno, E.e_name, EXTRACT(YEAR FROM AGE(E.born)) as age 
FROM emp E
ORDER BY EXTRACT(YEAR FROM AGE(E.born));