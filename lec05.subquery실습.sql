--1.회원별 주문 상품 통계
--회원아이디 상품번호 상품갯수 구매금액
--(조건:주문건이 없더라도 회원출력)

select u.user_id, og.good_seq, og.order_amount, og.order_price
from users u, orders o, orders_goods og
where u.user_seq = o.user_seq(+) and o.order_code = og.order_code(+)
order by u.user_id asc;

select u.user_id, og.good_seq, og.order_amount, og.order_price
from users u 
left outer join orders o on u.user_seq = o.user_seq
left outer join orders_goods og on o.order_code = og.order_code
order by u.user_id asc;

--2.업체별 공급 상품 리스트
--업체번호 업체명 상품번호 상품명
--(조건:상품이 없더라도 업체명 출력)
select c.com_seq, c.com_name, g.good_seq, g.good_name
from company c, company_goods cg, goods g
where c.com_seq = cg.com_seq(+) and cg.good_seq = g.good_seq(+)
order by com_seq asc, good_seq asc;

--3.회원관리
--정규직/비정규직 구분하여 출력 
--조건1:정규직이면A,비정규직이면B로 출력
--조건2:급여(1일 8시간 한달:20일 기준으로 계산)
--회원번호 회원명 정규/비정규여부 월급여
select tsal, tsal *8*20 from parttime;
(select u.user_seq, u.user_name,  'A' as gubun, asal
from users u , fulltime f
where u.user_seq = f.user_seq)
       UNION ALL
(select u.user_seq, u.user_name,  'B' as gubun, (tsal * 8 * 20) as asal
from users u , parttime p
where u.user_seq = p.user_seq)
;

--create table a(num number(2));
--create table b(num number(2));
--insert into a values(1);
--insert into a values(2);
--insert into a values(3);
--insert into b values(3);
--insert into b values(4);
--commit;

(select * from a)  UNION      (select * from b);
(select * from a)  UNION ALL  (select * from b);
(select * from a)  INTERSECT  (select * from b);
(select * from a)  MINUS      (select * from b);

--4.상품/주문관리
--주문된 상품별 판매량, 판매금액 출력
--조건:판매량이 높은 순으로 정렬
--상품번호 상품명 총판매량 총판매금액
select g.good_seq, g.good_name, og.order_amount, og.order_price
from  orders_goods og, goods g
where og.good_seq(+) = g.good_seq
order by og.order_amount desc;

select og.good_seq, g.good_name, sum(og.order_amount)as samount, sum(og.order_price) as sprice
from orders_goods og, goods g
where og.good_seq = g.good_seq
group by og.good_seq, g.good_name
order by samount desc;

--5. 사용자별 구매 통계
--회원아이디  총구매횟수   총구매금액
--조건1 : 구매금액이 높은 순 출력
select u.user_id, count(o.order_code)as total_count, sum(og.order_price)as total_price
from users u, orders o, orders_goods og
where u.user_seq = o.user_seq(+) 
  and o.order_code = og.order_code(+)
group by u.user_id
order by total_price desc;

select u.user_id, count(1) as cnt, sum(o.tot_price) as sprice
from orders o, users u
where o.user_seq = u.user_seq
group by u.user_id
order by sprice desc;

--6. 휴면 고객원통계
--구매실적이 전혀 없는 회원 목록 출력
--회원아이디 회원명  
--hong 홍씨

select user_id, user_name
from users
where user_seq not in (select user_seq from orders where user_seq is not null);

select user_id, user_name from users where user_seq not in (select distinct user_seq from orders);

select user_id, user_name
from ((select user_seq from users)
 minus
(select user_seq from orders group by user_seq))s, users u 
where s.user_seq = u.user_seq
;

--7. 전체 회원 목록 중 휴면 회원이 차지하는 비율?
--조건1 : 관리자 제외
--조건2: 휴면회원은 구매 실적이 전혀 없는 회원
-- 회원수   휴면회원비율
--------- 
--  1/4      25%
select 1 || '/' ||4 as 회원수
    , 25 || '%' as 휴면회원비율
from dual;

select distinct user_gubun from users; -- 관리자 구분하는거 'u'는 일반유저 'a'는 관리자

select count(*) from users where user_gubun = 'u'; --1
select count(*) from users where user_gubun = 'u' and user_seq not in (select user_seq from orders); --4

select (select count(*) from users where user_gubun = 'u'and user_seq not in (select user_seq from orders))
|| '/' ||
(select count(*) from users where user_gubun = 'u') as 회원수,
(select count(*) from users where user_gubun = 'u'and user_seq not in (select user_seq from orders))/
(select count(*) from users where user_gubun = 'u') *100  || '%' as 휴면회원비율
from dual;
-- 답
select cnt1 ||'/'|| cnt2 as 회원수,
        (cnt1/cnt2)*100 || '%' as 휴면회원비율
from
(select count(1) as cnt1 from users where user_seq not in (select distinct user_seq from orders)),
(select count(1) as cnt2 from users where user_gubun != 'a');

select 1 || '/' ||4 as 회원수
    , 25 || '%' as 휴면회원비율
from dual;


--8. 각 회원별로 매니저-회원 관계를 출력하시오
--조건1: 관리자 제외
--조건2: 매니저번호 오름차순 회원번호 오름차순 정렬
select m.user_id as 메니저, u.user_id as 회원
from users u
join users m on u.mgr_seq = m.user_seq
where u.user_gubun = 'u'
order by m.user_id asc, u.user_id asc; -- id가 아니라 seq

select * from users;

-- 
select m.user_id as 메니저,  u.user_id as 회원
from users u, users m
where u.mgr_seq = m.user_seq and u.user_gubun != 'a'
order by m.user_seq asc, u.user_seq asc;

select m.user_id as 메니저,  u.user_id as 회원
from (select user_id, user_seq, mgr_seq from users where user_gubun != 'a')u,
        (select user_id, user_seq, mgr_seq from users where user_gubun != 'a')m
where u.mgr_seq = m.user_seq
order by m.user_seq asc, u.user_seq asc;



-- ---------------------------------------------------------------------------------
/* where뒤 if문법 원래의 where 뒤에 쓰는거랑 같음
CASE
    WHEN____ THEN_____
    WHEN____ THEN_____
                    ELSE______   
END
*/
--EX)
select sal,
            (CASE
                WHEN sal < 1000 THEN 'a'
                WHEN sal < 2000 THEN 'b'
                                ELSE 'c'   
            END) as add
from emp;

--DECODE(컬럼,    'A' , 1,    'B', 2 ,    3) -- 단일값만 비교
select deptno,
        DECODE( deptno,     10 , '십',       20, '이십',   '삼십') as ddd -- 이도저도 아닌거 ex)'삼십'으로 처리 안하면 널나오니까 왠만해선 해주기
from emp;

-- 월별 급여 합
select hiredate, to_char(hiredate, 'mm') from emp;

select to_char(hiredate, 'mm')as hm, sum(sal) as ssal
from emp
group by to_char(hiredate, 'mm')
order by hm asc;

select
(select sum(sal) from emp where to_char(hiredate, 'mm') = '01') as mm01,
(select sum(sal) from emp where to_char(hiredate, 'mm') = '02') as mm02,
(select sum(sal) from emp where to_char(hiredate, 'mm') = '03') as mm03,
(select sum(sal) from emp where to_char(hiredate, 'mm') = '04') as mm04,
(select sum(sal) from emp where to_char(hiredate, 'mm') = '05') as mm05
from dual;

--안씨문법
select 
        sum (decode(to_char(hiredate, 'mm'), '01' ,1, 0)) as mm01,
        sum (decode(to_char(hiredate, 'mm'), '02' ,1, 0)) as mm02,
        sum (decode(to_char(hiredate, 'mm'), '03' ,1, 0)) as mm03,
        sum (decode(to_char(hiredate, 'mm'), '04' ,1, 0)) as mm04,
        sum (decode(to_char(hiredate, 'mm'), '05' ,1, 0)) as mm05
from emp;

-- 월별 합계
select 
        sum (decode(to_char(hiredate, 'mm'), '01' ,sal, 0)) as mm01,
        sum (decode(to_char(hiredate, 'mm'), '02' ,sal, 0)) as mm02,
        sum (decode(to_char(hiredate, 'mm'), '03' ,sal, 0)) as mm03,
        sum (decode(to_char(hiredate, 'mm'), '04' ,sal, 0)) as mm04,
        sum (decode(to_char(hiredate, 'mm'), '05' ,sal, 0)) as mm05
from emp;

select to_char(hiredate, 'mm')as mh, sum(sal)
from emp
group by to_char(hiredate, 'mm')
order by to_char(hiredate, 'mm') asc ;
-- ------------------------------------------------------------------------------------------------------------------------
-- 부서별 인원수
select deptno as 부서별,count(1) as cnt
from emp
group by deptno
order by deptno asc;

 select -- 이런 피벗방식은 값을 정확하게 알아야함. 10,20,30
(select count(1) as cnt from emp where deptno = 10) as cnt10,
(select count(1) as cnt from emp where deptno = 20) as cnt20,
(select count(1) as cnt from emp where deptno = 30) as cnt30
from dual;

-- ------------------------------------------------------------------------------------------------------------------------
-- 부서별 인원수 합
select deptno, sum(sal)
from emp
group by deptno;
---
select -- 스칼라 서브커리
    (select sum(sal) from emp where deptno=10) as d10,
    (select sum(sal) from emp where deptno=20) as d20,
    (select sum(sal) from emp where deptno=30) as d30
from dual;
--
select -- decode/case
    sum(decode( deptno,  10,sal   ,0  )) as d10,
    sum(decode( deptno,  20,sal   ,0  )) as d20,
    sum(decode( deptno,  30,sal   ,0  )) as d30
from emp;
--

select deptno ,job
from emp;

-- ------------------------------------------------------------------------------------------------------------------------
--9. 주문/상품/업체 대시보드 현황판
-- 총주문수량 총주문금액  총회원수  총업체수 총상품수
--       AMT      PRICE       UCNT       CCNT       GCNT
---------- ---------- ---------- ---------- ----------
--        48     244000          5          7         10

select
    (select sum(order_amount) from orders_goods) as amt,
    (select sum(order_price) from orders_goods) as price,
    (select count(1) from users) as ucnt,
    (select count(1) from company) as ccnt,
    (select count(1) from goods) as gcnt
from dual;

select
   (select sum(order_amount) from orders_goods) as amt,
    (select sum(order_price) from orders_goods) as pricet,
     (select count(1) from users) as ucnt,
    (select count(1) from company) as ccnt,
    (select count(1) from goods) as gcnt
from dual;

--10.월별 판매 실적....
--  1월   2월   3월   4월  
-- 20000  12000  50000

select to_char(order_date, 'mm') as mmo , sum(tot_price) tt 
from orders
group by to_char(order_date, 'mm');

select 
    (select sum(tot_price) from orders where to_char(order_date, 'mm') = '01')  as 월1
from dual;

select
    sum(decode(to_char(order_date, 'mm'), '01', tot_price, 0)) as 월1
from orders;

select
    sum((case when to_char(order_date, 'mm') = '01' then tot_price else 0 end)) as 월01
from orders;







