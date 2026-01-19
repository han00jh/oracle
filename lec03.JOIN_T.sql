-- 조인(JOIN) : from절에 2개이상 테이블을 사용하는 것
-- [INNER]                JOIN : N 테이블에서 참조되어지는 값을 가진 컬럼 연결
--                             : N 테이블의 이름이 같으면 SELF JOIN이라 칭함 
-- LEFT/RIGHT/FULL  OUTER JOIN : N 테이블에서 참조되어지는 값이 없어도 연결
-- ----------------------inner join----------------------------------------
select d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno = d.deptno     --일반적 1:1연결 PK=FK
    and d.deptno in (10,20)   --그외 조건들
order by dno;

select d.deptno as dno , d.dname , e.ename
from emp e  INNER JOIN dept d ON e.deptno = d.deptno  --ON 컬럼연결
where d.deptno in (10,20)
order by dno;
-- -------------------------------------------------------------------------
select  d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno(+) = d.deptno  
order by dno;

select e.empno, e.ename  ,    m.empno, m.ename
from emp e, emp m
where e.mgr = m.empno;

-- -------------------------------------------------------------------------
select  d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno(+) = d.deptno  
order by dno;

select  d.deptno as dno , d.dname , e.ename
--from emp e RIGHT outer JOIN dept d ON e.deptno = d.deptno   
from dept d left outer join emp e on e.deptno = d.deptno --위에 주석처리된거랑 같음
order by dno;
-- -------------------inner join 중 self join--------------------------------------------
select e.empno, e.ename, m.empno, m.ename
from emp e, emp m
where e.mgr = m. empno;

select e.empno, e.ename, m.empno, m.ename
from emp e inner join emp m on e.mgr = m.empno;
-- -------------------------------------------------------------------------
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;
-- ---------------------------inner join = 안쓰고 조인 됨-------------------------------------
select * from salgrade;

select e.sal, s.grade, s.losal, s.hisal
from emp e, salgrade s
where e.sal between s.losal and s.hisal;

select e.sal, s.grade, s.losal, s.hisal
from emp e inner join salgrade s on e.sal between s.losal and s.hisal;






