select * from users;

insert into users(useq, usid, upw) values(9,'park',999);
update users set upw=888, usid ='park2' where useq=9;
delete from users where useq=9;

select empno, ename, comm, sal from emp where comm <=0 or comm is null;
-- 사원의 연봉 : sal*12 +comm
select sal*12 +nvl(comm,0) from emp;

-- emp 테이블에서 deptno 10 또는 20인 사원의 empno, ename, comm, sal 출력
select empno, ename,comm, sal from emp where deptno =10 or deptno =20;

-- emp 테이블에서 deptno 30이고 직업이 SALESMAN인 사원의 empno, ename, comm, sal 출력
select empno, ename, comm, sal from emp where deptno=30 and job='SALESMAN';

------------------------------------------
--★★★BETWEEN A AND B
------------------------------------------
-- emp 테이블에서 sal 이 3000이상 5000이하 인 사원의  empno, ename, sal 출력
select empno, ename, sal from emp where sal >= 3000 and sal<=5000;
select empno, ename, sal from emp where sal between 3000 and 5000;

------------------------------------------
--★★★컬럼 IN (...값) : 여러 값 중 일치하는
--컬럼 NOT IN (...값) : 여러 값 중 일치하지 않는
------------------------------------------
select  empno, ename, sal, deptno from emp where deptno =10, or deptno=20;
select  empno, ename, sal, deptno from emp where deptno in(10,20);
select  empno, ename, sal, deptno from emp where deptno not in(10,20);
select  empno, ename, sal, deptno from emp where deptno in(10,20)
order by deptno asc;

-- 직업이 CLERK 이거나 MANAGER이거나 SALESMAN인 사원의 empno, ename, job 출력
select empno, ename, job from emp where job in('CLERK','MANAGER','SALESMAN');
select empno, ename, job from emp where job not in('CLERK','MANAGER','SALESMAN');

------------------------------------------
-- 컬럼 LIKE '%_' : 유사패턴
-- fullscan : 처음부터 끝까지 다 읽어서 오래걸림
------------------------------------------
-- ename이 s로 시작하는 empno, ename사원정보 출력
select ename from emp;
select empno, ename from emp where ename LIKE 'S%';

-- ename이 두번째 글자가 A인 empno, ename 사원정보 출력
select empno, ename from emp where ename like '_A%';
-- ename에 A가 들어간 empno, ename 사원정보 출력
select empno, ename from emp where ename like '%A%';

-- 부서번호 20 이고 직업이 CLERK 또는 ANALYST 인 사원정보 출력
select * from emp where deptno=20 and (job='CLERK' or job='ANALYST');
select * from emp where deptno=20 and job in('CLERK','ANALYST');

-- 정렬 :ORDER BY 컬럼 [ASC | DESC]
--      : ORDER BY    컬럼 [ASC | DESC], 컬럼 [ASC | DESC] 
-- ASC :오름차순, DESC : 내림차순
-- 사원정보 출력 deptno오름, 급여 내림
select * from emp 
order by deptno asc, sal desc;

-- deptno=10 또는 20인 사원정보 출력(deptno오름, 급여 내림)
select * from emp where deptno in(10,20)
order by deptno asc, sal desc;

-- deptno=20 또는 30이고 이름에 A들어가는 사원정보 출력(deptno오름, 급여 내림)
select * from emp where deptno in(20,30) and ename like'%A%'
order by deptno asc, sal desc;

-- 연봉 :sal*12+comm이 36000이상인 사원 정보 출력 연봉 오름차순
#select * from emp where sal*12 +nvl(comm,0) >=36000
#order by sal asc;
select emp.*,sal*12 +nvl(comm,0) as asal from emp where sal*12 +nvl(comm,0) >=36000
order by asal asc;
select sal*12 +nvl(comm,0) from emp where sal*12 +nvl(comm,0) >=36000
order by sal*12 +nvl(comm,0) asc;




