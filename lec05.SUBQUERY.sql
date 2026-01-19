-- ----------------------------------------------------------------
-- SUBQUERY : 중첩된 커리
-- SELECT, FROM(인라인뷰), WHERE
-- ----------------------------------------------------------------
--  JONES의 급여 /보다 많이 받는 사원의 empno, ename, sal  출력
-- = 0000 급여   /보다 많이 받는 사원의 empno, ename, sal  출력
select *from emp;
select sal from emp where ename = 'JONES';
select empno, ename, sal from emp where sal >(select sal from emp where ename = 'JONES');

-- 7876사원의 직업과 같고  7369사원의 급여보다 많이 받는 사원의 ename, job, sal 출력
select ename, job, sal
from emp
where job = (select job from emp where empno = 7876)
    and sal > (select sal from emp where empno = 7369);

--emp에서 최소 급여보다 많이 받는 사원의 ename, sal 출력 ** 차시평가에 시험 나옴
select ename, sal
from emp
where sal > (select min(sal) from emp);

--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
-- 각 부서별 최소 급여보다(이 중 하나라도) 많이 받는 사원의 ename, sal출력
-- any, all함정 : 각 부서별 최소 급여가 다름
--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
select min(sal)
from emp
group by deptno;

select deptno, ename, sal 
from emp 
where sal > any (950,800,1300);

select deptno, ename, sal
from emp
where sal > any (select min(sal) from emp group by deptno)
order by deptno asc;

-- 각 부서 내 부서별 최소 급여보다(이 중 하나라도) 많이 받는 사원의 ename, sal출력
select deptno, ename, sal
from emp
where sal > any (select min(sal) from emp group by deptno)
order by deptno asc;

select e.deptno, e.sal, e.ename
from emp e
where sal >(select min(sal)
            from emp
            where deptno = e.deptno --메인 쿼리에서 넘겨준 부서 번호
            group by deptno);
            
--다음 중 '각 직업(job)별로 해당 직업의 평균 급여보다 많이 받는 사원의 ename, job, sal'을 출력하는 올바른 상관 서브쿼리는 무엇인가요?
select ename, job, sal
from emp e
where sal > (select avg(sal)
            from emp 
            where job = e.job);
            
--다음 중 '자신의 직업(job) 평균 급여보다 적게 받는 사원'의 이름(ename)과 급여(sal)를 출력하는 올바른 쿼리는 무엇인가요?
select ename, sal
from emp e
where sal < (select avg(sal)
    from emp
    where job = e.job);

--   7521 사원의 직업과 같고 7654 사원의 부서와 같은 사원의 ename, job, dpetno 출력

select job from emp where empno = 7521;
select deptno from emp where empno = 7654;

select ename, job, deptno
from emp
where job = (select job from emp where empno = 7521)
     and deptno =(select deptno from emp where empno = 7654);

--   7521 사원의 직업과 같고 7521 사원의 부서와 같은 사원의 ename, job, dpetno 출력
select ename, job, deptno
from emp
where (job, deptno) = (select job, deptno from emp where empno = 7521);
 
--다음 중 '자신의 부서 평균 급여보다 많이 받는 사원'을 찾는 상관 서브쿼리로 올바른 것은 무엇인가요?
select deptno
from emp e
where sal>(select avg(sal)
            from emp
            where deptno = e.deptno);

--다음 중 '각 부서별로 가장 최근에 입사한 사원(입사일이 가장 늦은 사원)'의 ename, hiredate, deptno를 출력하는 올바른 상관 서브쿼리는 무엇인가요?
select ename, hiredate, deptno
from emp e
where hiredate =(select max(hiredate)
                    from emp
                    where deptno = e.deptno);

select *from emp;

-- ------from 뒤 테이블자리는 검색속도 향상을 위해 최대한 적은 조건 걸어서 넣기-(연산량줄이기)------------------------------------------
select e.mgr, m.empno
from (select * from emp where deptno in(10,20)) e,
      (select * from emp where deptno in(10,20)) m
where e.mgr = m.empno;

-- ----------------------------------------------------------------------------------------------------------------------------------
-- FROM 서브쿼리 : 인라인뷰:조회성, 보안에 강함
--원본 테이블 레코드를 줄이기 위한 목적
-- alias(알리어스=별칭)를 where에서 사용하고 싶은 경우(동일 연산을 반복하지 않음)
-- ----------------------------------------------------------------------------------------------------------------------------------
--원본 테이블 레코드를 줄이기 위한 목적
select e.mgr, m.empno
from (select * from emp where deptno in(10,20)) e,
      (select * from emp where deptno in(10,20)) m
where e.mgr = m.empno;

-- alias(알리어스=별칭)를 where에서 사용하고 싶은 경우(동일 연산을 반복하지 않음)
select *
from(select sal *12+nvl(comm, 0) as aa
    from emp)
where aa > 36000
order by aa asc;

-- SELECT 서브쿼리
select count(1) as cnt10 from emp where deptno =10;
select count(1) as cnt10 from emp where deptno =20;

select (select count(1) as cnt10 from emp where deptno =10) as CNT10, 
        (select count(1) as cnt10 from emp where deptno =20) as CNT20,
        (select count(1) as cnt10 from emp where deptno =30) as CNT30
from dual;

select *from emp;



/*
-- 위 컬럼과 비교하는 함수
   LAG(column) OVER (ORDER BY 비교컬럼1, 비교컬럼2, ... ) 
                    ㄴ 무작위 비교하면 안되고, 순차적으로 비교(바로 위 컬럼과 비교하도록 순서 제공)
-- 특정 조건을 비교하는 함수
   DECODE(기준, 비교, 참일 때, 거짓일 때)

-- 위 data와 같으면 빈칸, 아니면 해당 data를 출력하는 함수
   DECODE(LAG(기준컬럼) OVER (ORDER BY(순서컬럼1, 순서컬럼2, ..), 기준컬럼, '같을때 표시 형식', 기준컬럼)
*/
SELECT 
        -- 이전 행과 부서번호가 같으면 빈칸, 다르면 부서번호 표시
        DECODE  (LAG(e.deptno) OVER (ORDER BY e.deptno, e.sal), e.deptno, ' ', e.deptno) AS DEPTNO,
        -- 이전 행과 최소급여가 같으면 빈칸, 다르면 최소급여 표시
        DECODE(LAG(min_val) OVER (ORDER BY e.deptno, e.sal), min_val, ' ', min_val) AS MIN_SAL,
        e.ename, 
        e.sal    
FROM (  SELECT 
            deptno, ename, sal,
            (SELECT MIN(sal) FROM emp WHERE deptno = t.deptno) as min_val
        FROM emp t
      ) e    
WHERE 
        e.sal > e.min_val
ORDER BY
        e.deptno, e.sal;

