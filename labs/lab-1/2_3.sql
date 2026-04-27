SELECT E.tabno 
FROM emp E
WHERE E.salary <
(SELECT AVG(E.salary) FROM emp E)