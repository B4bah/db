SELECT E.depno, E.e_name, CH.child_name, CH.born 
FROM emp E, children CH 
ORDER BY E.e_name, CH.born;