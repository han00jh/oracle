-- -------------------------------------------
-- Sub Query : 중첩된 쿼리
-- SELECT, FROM(인라인뷰), WHERE 
-- -------------------------------------------
--  2975급여      /  보다 많이 받는 사원의 empno, ename, sal  출력
--  JONES의 급여   /  보다 많이 받는 사원의 empno, ename, sal  출력
select sal from emp where ename= 'JONES';

select empno, ename, sal from emp where sal > 2975;

select empno, ename, sal from emp where sal > ( select sal from emp where ename= 'JONES' );

-- 7876사원의 직업과 같고  
-- 7369사원의 급여보다 많이 받는 
-- 사원의 ename, job, sal 출력
select job from emp where empno=7876;
select sal from emp where empno=7369;

select ename, job, sal
from emp 
where job = (select job from emp where empno=7876)
  and sal > (select sal from emp where empno=7369);

-- emp에서 최소 급여보다 많이 받는 사원의 ename, sal 출력
select min(sal) from emp;
select ename, sal
from emp
where sal > (select min(sal) from emp);

-- ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
-- 각 부서별 최소 급여보다(이 중 하나라도) 많이 받는 사원의 ename, sal 출력
-- ===============================================================
select min(sal) from emp   --30	950    --20	800   --10 1300
group by deptno;   
select deptno, ename, sal
from emp
where sal >ANY  (select  min(sal) from emp group by deptno);
--where sal >ANY (950,800,1300);

-- ===============================================================
-- 각 부서 내에서 부서별 최소 급여보다(이 중 하나라도) 많이 받는 사원의 ename, sal 출력
select e.deptno, e.sal, e.ename  
from emp e
where e.sal > ( select min(s.sal)    
              from emp s
              where s.deptno = e.deptno   -- ★★★★★
              group by s.deptno)
order by deptno;
              
-- 7521 사원의 직업과 같고 
-- 7654 사원의 부서와 같은 
-- 사원의 ename, job, dpetno 출력
select job    from emp where empno=7521;       --SALESMAN
select deptno from emp where empno=7654;    --30
-- 'SALESMAN' 30  사원의 ename, job, dpetno 출력
select ename, job, deptno 
from emp
where job    = (select    job from emp where empno=7521)
  and deptno = (select deptno from emp where empno=7654) ;

-- 7521 사원의 직업과 같고 7521 사원의 부서와 같은 
-- 사원의 ename, job, dpetno 출력
select job    from emp where empno=7521;       --SALESMAN
select deptno from emp where empno=7521;       --30
select job, deptno    from emp where empno=7521;       --SALESMAN --30
-- 'SALESMAN' 30  사원의 ename, job, dpetno 출력
select ename, job, deptno 
from emp
where  (job, deptno) = (select job, deptno from emp where empno=7521);
--where job    = (select    job from emp where empno=7521)
--  and deptno = (select deptno from emp where empno=7521) ;

-- =============================================================
-- FROM 서브쿼리 : 인라인뷰
-- 원본 테이블 레코드를 줄이기 위한 목적
-- alias를 where에서 사용하고 싶은 경우(동일 연산 반복 X)
-- =============================================================
select * 
from emp --(select * from emp)   --인라인 뷰
where deptno = 10;

--14 * 14 = 196
--8  * 14 = 112
--8  * 8  = 64
select e.mgr , m.empno
from (select mgr, empno from emp where deptno in (10,20)) e
   , (select mgr, empno from emp where deptno in (10,20)) m
where e.mgr = m.empno
; 

-- alias를 where에서 사용하고 싶은 경우(동일 연산 반복 X)
select *
from ( select sal*12+nvl(comm,0) as aa 
       from emp)
where aa > 36000
order by aa asc;


-- =============================================================
-- SELECT 서브쿼리
-- =============================================================
select count(1) as cnt10 from emp where deptno = 10;
select count(1) as cnt20 from emp where deptno = 20;

select deptno, count(1)
from emp
group by deptno; 

select (select count(1) as cnt10 from emp where deptno = 10) as CNT10
     , (select count(1) as cnt20 from emp where deptno = 20) as CNT20 
     , (select count(1) as cnt20 from emp where deptno = 30) as CNT30 
from dual;

--CNT10   CNT20     CNT20
-------   -----    -----
--3        5         6




-- ------------------------------------------------------
-- SUBQUERY
-- EMP 테이블에서 가장 많은 사원이 속해있는 부서의 부서번호, 사원수
-- ------------------------------------------------------
select  max(count(1)) from emp group by deptno;  --6

-- ------------------------------------------------------
-- 방법1) having & 서브쿼리
-- ------------------------------------------------------
select deptno, count(1) as cnt
from emp
group by deptno
having count(1) = (select  max(count(1)) from emp group by deptno);

-- ------------------------------------------------------
-- 방법2) rownum & 서브쿼리(인라인뷰)
-- ------------------------------------------------------
select rowid , rownum, e.*
from emp e;

select rownum, deptno, cnt
from (
    select  deptno, count(1) as cnt
    from emp
    group by   deptno
    order by cnt desc)
where rownum = 1;


-- ------------------------------------------------------
-- 방법3) 인라인뷰 & 조인
-- ------------------------------------------------------
select t1.deptno, t1.cnt1
from  (select deptno, count(1) as cnt1 from emp group by deptno) t1 , 
      (select    max(count(1)) as cnt2 from emp group by deptno) t2
where t1.cnt1 = t2.cnt2;


-- ------------------------------------------------------
-- 방법N) 상관 서브쿼리 : 비추
-- ------------------------------------------------------
select e.deptno, count(1) as cnt
from emp e
group by e.deptno
having count(1) >ALL (select count(1) from emp where deptno != e.deptno group by deptno );

-- ------------------------------------------------------
-- 방법N) 오라클 - 분석함수
-- ------------------------------------------------------
select *
from (
    SELECT deptno,
                count(1) as cnt,
           RANK() OVER(ORDER BY count(1) desc) AS rk
    FROM emp
    group by deptno)
where rk=1;
 



