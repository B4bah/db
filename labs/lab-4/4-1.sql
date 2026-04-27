-- -- 4-1
-- SELECT DISTINCT J_2.jn FROM S, (SELECT J.jn, J.city, SPJ.sn FROM J, SPJ
-- WHERE SPJ.jn = J.jn) J_2
-- WHERE S.sn = J_2.sn AND J_2.city != S.city ORDER BY J_2.jn;

-- -- 4-2
-- SELECT S.sname FROM S
-- WHERE s.sn IN (SELECT SPJ.sn
-- FROM SPJ
-- WHERE SPJ.pn = 'P2');

-- -- 4-3
-- SELECT P.pn FROM P
-- WHERE P.pn IN (
-- 	SELECT SPJ.pn FROM SPJ WHERE SPJ.jn IN (
-- 		SELECT J.jn FROM J WHERE J.city = 'London')) ORDER BY P.pn;

-- -- 5-1
-- SELECT P.pn FROM P
-- WHERE P.pn IN (
-- 	SELECT SPJ.pn FROM SPJ WHERE SPJ.sn IN (
-- 		SELECT S.sn FROM S WHERE S.city = 'London'))
-- OR P.pn IN (
-- 	SELECT SPJ.pn FROM SPJ WHERE SPJ.jn IN (
-- 		SELECT J.jn FROM J WHERE J.city = 'London'));

-- 5-2
SELECT S.sname FROM S
WHERE S.sn IN (
	SELECT SPJ.sn FROM SPJ WHERE SPJ.pn IN (
		SELECT P.pn FROM P WHERE P.color = 'red'));