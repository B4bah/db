-- SELECT E.tabno, E.e_name, CH.child_name 
-- FROM emp E, children CH
-- WHERE E.tabno = CH.tabno

SELECT E.tabno, E.e_name FROM emp E
WHERE E.tabno IN
(SELECT E.tabno 
FROM emp E
EXCEPT 
SELECT CH.tabno FROM children CH);

-- SELECT E.tabno FROM emp E
-- WHERE NOT EXISTS
-- (SELECT CH.tabno FROM children CH WHERE E.tabno = CH.tabno)