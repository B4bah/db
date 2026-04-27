SELECT E.tabno, E.depno, E.salary
FROM emp E
WHERE E.depno IN ('2', '3') AND E.salary > 46000;