SELECT E.tabno, E.salary, E.salary * 0.13 as incoming_tax, E.salary * 0.01 as union_tax, E.salary - E.salary * 0.13 - E.salary * 0.01 as final_salary
FROM emp E