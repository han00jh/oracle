-- JOIN 조인 : from절에 2개 이상 테이블을 사용하는 것 
-- [INNER]          JOIN : N 테이블에서 참조되어지는 값을 가진 컬럼 연결
-- [INNER]          JOIN : N 테이블의 이름이 같으면 SELF JOIN이라 칭함
--  LEFT/RIGHT/FULL OUTER JOIN : N 테이블에서 참조되어지는 값이 없어도 컬럼 연결

select d.deptno as dno, d.dname, e.ename
from emp e, dept d
where e.deptno = d.deptno --일반적 1:1연결 PK=FK
    and d.deptno in (10,20) --그외 조건들
order by dno;
-- ANSIver
select d.deptno as dno, d.dname, e.ename
from emp e 
inner join dept d on e.deptno = d.deptno
where d.deptno in(10,20)
order by dno;


select emp.ename, dept.dname, emp.deptno as eno , dept.deptno as dno --dept.deptno가원본
from emp, dept
where emp.deptno = dept.deptno -- 일반적 1:1매칭 PK=FK
order by eno;


select emp.ename, dept.dname, dept.deptno as dno
from emp, dept
where emp.deptno(+) = dept.deptno 
order by dno;

select e.empno, e.ename, m.empno, m.ename
from emp e,emp m
where e.mgr = m.empno;

select d.deptno as dno, d.dname, e.ename
from emp e, dept d
where e.deptno = d.deptno
order by dno;
--ANSIver
select d.deptno as dno, d.dname, e.ename
from emp e 
inner join dept d on e.deptno = d.deptno
order by dno;


select * from emp;
select * from dept;
select *
from emp, dept
where emp.deptno = dept.deptno
order by ename asc, dept.deptno asc;

-- -------------------------------------------------------------------------
select  d.deptno as dno , d.dname , e.ename
from emp e, dept d
where e.deptno(+) = d.deptno  
order by dno;

select  d.deptno as dno , d.dname , e.ename
--from emp e RIGHT outer JOIN dept d ON e.deptno = d.deptno   
from dept d left outer join emp e on e.deptno = d.deptno --위에 주석처리된거랑 같음
order by dno;
-- -------------------------------------------------------------------------





