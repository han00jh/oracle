-- 조인(JOIN) : from절에 2개이상 테이블을 사용하는 것
-- [INNER]                JOIN : N 테이블에서 참조되어지는 값을 가진 컬럼 연결
--                             : N 테이블의 이름이 같으면 SELF JOIN이라 칭함 
-- LEFT/RIGHT/FULL  OUTER JOIN : N 테이블에서 참조되어지는 값이 없어도 연결
-- ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

-- -------------------INNER JOIN----------------------------------------------
select d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno = d.deptno     --일반적 1:1연결 PK=FK
    and d.deptno in (10,20)   --그외 조건들
order by dno;

select d.deptno as dno , d.dname , e.ename
from emp e  INNER JOIN dept d    ON e.deptno = d.deptno  --ON 컬럼연결
where d.deptno in (10,20)
order by dno;
-- -----------------------------OUTER JOIN--------------------------------------------
select  d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno(+) = d.deptno
order by dno;

select  d.deptno as dno , d.dname , e.ename
--from dept d LEFT OUTER JOIN  emp e   ON e.deptno = d.deptno  
from emp e RIGHT OUTER JOIN  dept d   ON e.deptno = d.deptno  
order by dno;
-- ---------------------------- INNER JOIN 중 SELF JOIN ------------------------------------------
select e.empno, e.ename  ,    m.empno, m.ename
from emp e, emp m
where e.mgr = m.empno;

select e.empno, e.ename  ,    m.empno, m.ename
from emp e INNER JOIN emp m ON e.mgr = m.empno;
-- ----------------------------INNER JOIN  = 안쓰고도 조인된다 --------------
select  * from SALGRADE;

select e.sal  ,  s.grade, s.losal, s.hisal
from emp e, SALGRADE s
where e.sal between s.losal and s.hisal;

select e.sal  ,  s.grade, s.losal, s.hisal
from emp e INNER JOIN SALGRADE s ON e.sal between s.losal and s.hisal;
-- -------------------------------------------------------------------------



-- -------------------------------------------------------------------------

