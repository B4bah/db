SELECT E.depno, COUNT(*) as emp_count
FROM emp E
GROUP BY E.depno