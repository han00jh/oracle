
-- 컬럼 조회 
select * from emp;
select empno, ename, sal from emp;
select empno, ename, (sal + deptno) AS dd, sal+100 AS aa from emp;

-- 별칭(alias)
-- 컬럼 : 컬럼 [AS] 별칭
-- 테이블 : 테이블   별칭 ,[AS]사용 불가
select empno as eno, ename as enm from emp e;

-- 가감산
-- 컬럼타입 : 수치형, 날짜(날짜에서의 연산은 일수, 일자 가감산)
select sal+100 AS aa from emp;
select hiredate, hiredate+1 as h2 from emp;

-- 합치기(||:버티컬)
-- 컬럼타입 : 글자
select (ename ||'-'|| job) as aa from emp;
--------------------------------------------------------------
-- ★★★★★ NULL, null _ Unkown Value(알려지지 않은 값) ★★★★★
-- null에는 어떠한 연산을 해도 null
--------------------------------------------------------------
select sal, comm, sal+comm as aa from emp;
select * from emp where comm >0;
select * from emp where comm !=0;
select * from emp where (comm is null) or (comm <=0); -- 커미션 안받는 사원
select * from emp where (comm is not null) and (comm >0); -- 커미션 받는 사원 !=은 음수인 값이 나올 수 있어서 안전빵으로 >
-- ★★★★★ NVL(컬럼, 바꿀값)
select comm, nvl(comm, 0) from emp;
select sal, comm, sal+nvl(comm,0) as aa from emp;
select sal, comm, sal+comm as aa from emp;

create table test(
eno number primary key,
bonus number not null,
sal number default 100,
dno number
);
insert into test(eno,bonus) values(111,0);
insert into test(eno,bonus) values(111,20);
select * from test;

--날짜
-- HIREDATE DATE
-- 오늘 날짜 : sysdate, now() => mysql 또는 maria용
select hiredate, to_char(hiredate, 'YYYY-MM-DD') as h2 from emp;
select sysdate from dual; -- dual: 오라클 기본 임시테이블
select * from dual; -- from 자리에 쓸거 없으면 dual쓰기 더미데이터라

select hiredate from emp;
select hiredate,trunc((sysdate - hiredate)/365) as yy from emp; -- trunc : 소수점 버리기

-- 중복처리 : distinct
-- distinct 컬럼
-- group by 컬럼
select distinct deptno from emp;
select distinct job from emp;
select distinct deptno, job from emp;

select deptno from emp
group by deptno;

-- 테이블 구조보기
desc dept;


--------------------------------------------------------------
-- 타입캐스팅(포맷팅)
--------------------------------------------------------------
-- 날짜 -> 글자
select hiredate, to_char(hiredate, 'YYYY-MM-DD') as h2 from emp;

-- 글자 -> 날짜
select hiredate, to_date('1980-07-07', 'YYYY-MM-DD') as h2 from emp;

-- 숫자 ->글자
select deptno, to_char(deptno) from emp;

-- 글자 ->숫자
select to_number('20')+1 from dual;

