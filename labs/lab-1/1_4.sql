SELECT E.tabno, E.e_name, E.post 
FROM emp E
WHERE E.post IN ('программист', 'сист.программист')