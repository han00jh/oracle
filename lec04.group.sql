-- ----------------------------------------------------------------
-- 그룹함수
-- ----------------------------------------------------------------
-- max(컬럼), min(컬럼), avg(컬럼), sum(컬럼), count(컬럼)
/*
SELECT
FROM
[WHERE]
[GROUP BY] -- [HAVING]
[ORDER BY]
*/


select round(12.3456 ,0) from dual; --round(12.345,0) = 12 0부분 소수점 자리 표시
select deptno,
        max(sal) as smx, min(sal) as smn,
        round(avg(sal),0)as savg, 
        sum (sal)as ssum, count(sal) as scnt
from emp
group by deptno
order by deptno asc
;


select round(12.3456 ,0) from dual; --round(12.345,0) = 12 0부분 소수점 자리 표시

select deptno,
        max(sal) as smx, min(sal) as smn,
        round(avg(sal),0)as savg, 
        sum (sal)as ssum, count(sal) as scnt
from emp
where deptno in(10,20)
group by deptno
having max(sal) > 3000
order by deptno asc;

-- ----------------------------------------------------------------
--   EMP 테이블에서 부서인원이 4명보다 많은 부서의  부서번호, 인원수, 급여합 출력
select deptno,count(1), sum(sal)
from emp
group by deptno
having count(1)>4;

--   EMP 테이블에서 가장 많은 사원이 속해있는 부서의 사원 수
select max(count(1)) as mxcnt
from emp
group by deptno;


-- 부서별 평균 급여를 부서번호, 평균급여(소수점 2자리) 출력

select deptno, round(avg(sal),2) as svgsal
from emp
group by deptno;

-- 직업별 사원수, 최고급여 출력
select job, count(1)as cnt, max(sal) as maxsal
from emp
group by job
order by maxsal asc;

-- 부서별 급여 총합이 9000 이상인 부서번호, 급여총합 출력
select deptno, sum(sal) as sumsal
from emp
group by deptno
having sum(sal) >= 9000;

-- 부서별, 직업별 평균 급여 출력
select deptno, job, floor(avg(sal)) as sal
from emp
group by deptno, job
order by deptno asc, job asc;

--부서별, 입사년도별 평균급여(소수점올림) 출력
select deptno, to_char(hiredate, 'yyyy') as yy, ceil(avg(sal)) as csal
from emp
group by deptno, to_char(hiredate, 'yyyy')
order by deptno asc, yy asc;

-- ----------------------------------------------------------------------------------
/*
오라클에서
반올림 : round(컬럼,소수점자리)
올림 : ceil(컬럼)  -> 정수만 출력
버림 : floor(컬럼)->정수만 출력, trunc(컬럼,소수점자리)
*/

select round(12.789, 2) from dual; --12.79
select round(12.789, -1) from dual; --10
select round(12.789, 0) from dual; --13

select ceil(12.789) from dual; --13
select ceil(12.1) from dual; --13

select floor(12.1) from dual; --12
select floor(12.789) from dual; --12

select trunc(12.123, 1) from dual; --12.1
select trunc(12.789, 0) from dual; --12
select trunc(12.789, -1) from dual; --10

select sysdate from dual;

-- ----------------------------------------------------------------
-- 원화 표현
-- 천단위 콤마 :000, 999
-- 99로 하면 빈자리는 비어보이고, 00은 빈자리를 0으로 채워서 보여줌
select to_char (1234567, '999,999,999') as num_sep from dual ;
select to_char (1234567, '009,999,999') as num_sep from dual ;

-- 입력값이 지정 형식을 넘어가면 ###로 오류남
select to_char (1234567890, '9,9999,9999') as num_sep from dual ;


/* 문자열의 경우 REPLACE('문자열', '기존 형태', '변경될 형태') 로 변환 */
-- select to_char('sdafe sae', 'aa,aaaa,aaaaa,aaa,') as char_sep from dual ;
select REPLACE ('what is love', ' ', '|') as char_rep from dual ;

-- 문자열 합치기는 || 표시 활용 (Concatenation)
select 'What' || ' ' || 'is' || ' ' || 'love' as char_con from dual ;
-- ----------------------------------------------------------------
-- SUBQUERY
-- EMP 테이블에서 가장 많은 사원이 속해있는 부서의 부서번호, 사원 수
-- ----------------------------------------------------------------



