

/* SUB_QUERY 
    : 중첩 query ( at. SELECT / FROM / WHERE )
    
    cf. FROM에 놓이는 sub-query는 'IN_LINE_VIEW' 라고 얘기함
         - 원본 테이블 레코드를 줄이기 위한 목적
         - Alias를 where절에 사용하고 싶은 경우 (동일 연산 반복은 불가)
      
      
    cf. sub-query가 중첩된 경우, 가장 depth가 깊은 query 부터 찾아 올라가면서 이해
    
    
    ***** 출력 결과값이 single / multi 에 따라서 사용하는 연산자가 상이함 *****
            => 걍 항상 sub-query에서는 multi 연산자 쓰면 오류는 안남 
                (근데 single 연산자보다 multi 연산자가 연산 속도가 떨어지긴 함)
                  - single 연산자 : <, > , = , <>(!=) 등
                  - multi  연산자 : IN, ANY, ALL 등
*/




-- JONES 보다 급여를 많이 받는 사람의 empno, ename, sal 출력
    -- JONES의 급여 ==> scalar 값으로 나와야 하므로, select에서 1개의 값만 출력되야함
        -- 무조건 싱글 출력은 아니어도 되는데(multi-row나 multi-column도 가능)                 
        -- single / multi에 따라 사용하는 ***** 연산자가 상이함 *****

select sal   from emp   where ename = 'JONES' ;
        
-- JONES의 급여 = 2975        
select  empno, ename, sal
from    emp
where   sal > 2975 ;
        
        
-- JONES의 급여 보다 많이 받는 사람의 empno, ename, sal 출력               
select  empno, ename, sal
from    emp
where   sal > (select   sal 
               from     emp 
               where    ename = 'JONES'
               ) ;
        

-- empno 7876 사원과 직업이 같으면서, empno 7369 사원 급여보다 많이 받는 사원?
select 
        ename, job, sal
from 
        emp
where 
        job = (select job   from emp   where empno=7876)
    and 
        sal > (select sal   from emp   where empno=7369) ;
        
        
-- emp에서 최소 급여보다 많이 받는 사원?
select
        ename, sal
from    
        emp
where
        sal > any ( select  min(sal)
                    from    emp );
        
        
-- 각 부서별 최소 급여보다 많이 받는 사원?
select      deptno, min(sal)
from        emp 
group by    deptno
;
                    
select
        e1.deptno, 
        e1.ename, 
        e1.sal
from 
        emp e1
where 
        e1.sal >  ( select  min(e2.sal)
                    from    emp e2
                    where   e2.deptno = e1.deptno )
order by
        e1.deptno asc, 
        e1.sal asc 
;
        
        
-- 이거 실행하면 중복값도 계속 나옴                
select
        e.deptno,
        ( select    min(e2.sal)
          from      emp e2
          where     e2.deptno = e.deptno ) as min_sal_in_dept,        
        e.deptno, 
        e.ename, 
        e.sal
from 
        emp e
where 
        sal > ( select  min(e2.sal)
                from    emp e2 
                where   e2.deptno = e.deptno)
order by
        e.deptno asc,
        e.sal asc 
;


/*
-- 위 행(Row)과 비교하는 함수
   LAG(column) OVER (ORDER BY 비교컬럼1, 비교컬럼2, ... ) 
                    ㄴ 무작위 비교하면 안되고, 순차적으로 비교(바로 위 행과 비교하도록 순서 제공)
-- 특정 조건을 비교하는 함수
   DECODE(기준, 비교, 참일 때, 거짓일 때)

-- 위 데이터와 같으면 빈칸, 아니면 해당 데이터를 출력하는 함수
   DECODE(LAG(기준컬럼) OVER (ORDER BY 순서컬럼1, 순서컬럼2, ...), 기준컬럼, '같을때 표시 형식', 기준컬럼)
*/

SELECT 
    -- 이전 행과 부서번호가 같으면 빈칸, 다르면 부서번호 표시
        DECODE(LAG(e.deptno) OVER (ORDER BY e.deptno, e.sal), e.deptno, ' ', e.deptno)  AS DEPTNO,
    -- 이전 행과 최소급여가 같으면 빈칸, 다르면 최소급여 표시
        DECODE(LAG(min_val)  OVER (ORDER BY e.deptno, e.sal), min_val,  ' ', min_val)   AS MIN_SAL,
        e.ename, 
        e.sal    
FROM (  SELECT 
            deptno, 
            ename, 
            sal,
            (SELECT MIN(sal)  FROM emp  WHERE deptno = t.deptno)    as min_val
        FROM emp t
      ) e    
WHERE 
        e.sal > e.min_val
ORDER BY
        e.deptno, e.sal
;


-- 7521 사원과 동일 직업, 7654 사원과 부서 동일 사원 출력
select 
        empno, ename, deptno, job
from
        emp
where
        job    = ( select   job
                    from    emp
                    where   empno = 7521)
    and
        deptno = ( select   deptno
                    from    emp
                    where   empno = 7654 )
order by
        empno asc 
;


-- 7521 사원의 직업과 부서가 같은 사원 출력
select 
        empno, ename, deptno, job
from
        emp
where
        (deptno, job) = (select  deptno, job
                         from    emp
                         where   empno = 7521) 
order by
        deptno asc 
;
                         
                         
-- 중복 공백처리
select 
        DECODE(LAG(deptno) OVER(ORDER BY empno asc), deptno, ' ', deptno)   as deptno,
        DECODE(LAG(job)    OVER(ORDER BY empno asc), job,    ' ', job)      as job,
        empno, ename
from
        emp
where
        (deptno, job) = (select  deptno, job
                         from    emp
                         where   empno = 7521) 
order by
        empno asc 
;
                         

-- 서브쿼리 활용해서 데이터 연산 범위 줄이는 방법
-- 원본 (emp_14 * emp_14 로 연산)
select 
        e.mgr, 
        m.empno
from
        emp e,
        emp m
where 
        e.deptno in(10,20)
    and
        e.mgr = m.empno
;
                         
-- 연산 처리 줄인 것 (7 * 7)
select 
        e.mgr, 
        m.empno
from
        (select *   from emp    where deptno in(10,20)) e,
        (select *   from emp    where deptno in(10,20)) m
where 
        e.mgr = m.empno
;
                                         
                         
-- 연산 처리 더 줄인 것 (전체 컬럼 -> 필요한 컬럼 1개씩)
select 
        e.mgr, 
        m.empno
from
        (select mgr   from emp  where deptno in(10,20)) e,
        (select empno from emp  where deptno in(10,20)) m
where 
        e.mgr = m.empno
;
                                    

-- sub-query 활용하여 where 절에서 alias 사용 가능한 방법
-- 해당 alias는 from에서 선언해서 where 절에서도 사용 가능
-- cf.[ FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY > LIMIT/OFFSET ]
select 
        *
from   
        ( select sal*12 + nvl(comm,0)       as alias
          from emp )
where 
        alias > 36000
order by 
        alias 
;


-- 10번 부서 사원 수
select 
        count(empno)     as cnt_10
from
        emp
where 
        deptno = 10 
;
        

-- 10, 20 부서 인원을 한 줄에 출력하는 법
select 
        (select count(empno)  from emp  where deptno = 10)      as cnt_10,
        (select count(empno)  from emp  where deptno = 20)      as cnt_20
from    
     -- 여기 emp 쓰면 같은 출력이 14줄 나옴
        dual 
;


-- 행 <-> 열 반전시키기
select      deptno, count(1) as cnt_empno
from        emp
group by    deptno
;


select  (select count(1)   from emp   where deptno = 10)    as cnt_empno_10, 
        (select count(1)   from emp   where deptno = 20)    as cnt_empno_20,
        (select count(1)   from emp   where deptno = 30)    as cnt_empno_30 
from    dual
;

-- 가장 많은 사원이 속한 부서의 부서번호, 사원수
select 
        deptno          as max_emp_deptno ,
        count(empno)    as count_emp
from 
        emp
group by 
        deptno
having  
        count(empno) = (
                        select
                                max(count(empno))
                        from
                                emp 
                        group by 
                                deptno 
                        ) 
order by
        deptno 
;



-- select절에 넣는 법
select 
        1,
        (select     deptno
         from       emp 
         group by   deptno
            having  count(empno) = (select     max(count(1))
                                    from       emp
                                    group by   deptno  ))        as max_emp_deptno ,
            
        (select     max(count(empno))
         from       emp 
         group by   deptno          )                            as count_emp
from 
        dual 
;




-- cf.rownum 활용 (1)
select 
    --  열 넘버, 메모리가 저장된 주소
        rownum,  rowid,             e.*
from
        emp e
;


-- cf.rownum 활용 (2)
select 
        deptno, cnt
from
       (select      deptno, count(1) as cnt
        from        emp
        group by    deptno
        order by    cnt desc )
where 
        rownum = 1
;



-- JOIN 활용
select
        deptno, t1.cnt1 as max_emp_num
from
        (select     deptno, count(1)    as cnt1
         from       emp
         group by   deptno  )                       t1
    JOIN
        (select     max(count(1))       as cnt2
         from       emp
         group by   deptno  )                       t2
    ON
        t1.cnt1 = t2.cnt2
;


