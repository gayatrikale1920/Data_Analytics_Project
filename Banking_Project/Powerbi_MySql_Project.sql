create database banks;
use banks;
select * from transactionsTable;
select * from customertable;

create view Total_Transaction as
select transaction_type ,sum(transaction_amount) value from transactionstable group by transaction_type;

select * from Total_Transaction;

alter table transactionstable 
modify column transaction_date  date;

create view Min_Max_Date as
select max(transaction_date) as max_date,min(transaction_date) as min_date from transactionstable ;

select * from Min_Max_Date;
SET SQL_SAFE_UPDATES =0; 

update transactionstable set transaction_date = str_to_date(transaction_date,'%Y-%m-%d');
 
 create view month_wise_2022_Transactions as
 select Date_format(transaction_date,'%M-%Y')as Date ,sum(transaction_amount) as value from transactionstable
 where transaction_date between '2022-01-01' and '2022-12-31' group by date  order by value desc;
 
 select * from month_wise_2022_Transactions;
 
create view Month_Wise_Total_NumberOfTransaction_2023 as
 select month(transaction_date) as month ,count(*) as total_transactions from transactionstable 
 where year(transaction_date)='2023' 
 group by month order by month ;
 
 select * from Month_Wise_Total_NumberOfTransaction_2023 ;
 
 -- •	Find the Count of customers that transacted on 2023-08-29
 Delimiter //
 create procedure customer_count()
    begin
    select count(*) as customer_count , transaction_date from transactionstable where transaction_date = '2023-08-29';
    end //
Delimiter ;
call customer_count();
-- •	Find --Debit transactions (by the transaction types, that is, debit and credit)
delimiter //
create procedure TotalTransaction_2023_08_29()
begin
select transaction_type ,sum(transaction_amount)Value from transactionstable where transaction_date = '2023-08-29' group by transaction_type;
end //
delimiter ;

call TotalTransaction_2023_08_29;
-- Net Profit
-- 2 methods: Subquery and CTE
create view net_profit_2023_08_29 as
select(totalCredits - totalDebits)as net_profit from (select sum(case when transaction_type = 'credit' then transaction_amount else 0 end )as totalCredits,
sum(case when transaction_type = 'debit' then transaction_amount else 0 end ) as totalDebits from transactionstable 
where transaction_date = '2023-08-29' )as subquery;

select * from net_profit_2023_08_29;

with TransactionSummery as
(select sum(case when transaction_type = 'credit' then transaction_amount else 0 end) as credit,
sum(case when transaction_type = 'debit' then transaction_amount else 0 end)as debit
from transactionstable
where transaction_date = '2023-08-29')
select (credit - debit) as net_profit from TransactionSummery;

-- •	Find --Top 3 Customers in the month 
create view top_3_customer as
select A.customer_id ,B.customer_name , sum(case when A.transaction_type = 'credit' then A.transaction_amount else 0 end) as Credit ,
sum(case when A.transaction_type = 'debit' then A.transaction_amount else 0 end) as debit ,
sum(case when A.transaction_type = 'credit' then A.transaction_amount else 0 end - case when A.transaction_type = 'debit' then 
A.transaction_amount else 0 end ) as net_profit
from transactionstable A join customertable B 
using(customer_id)
where A.transaction_date <= '2023-08-30' and A.transaction_date>='2023-08-01'
group by A.customer_id,B.customer_name 
order by net_profit desc limit 3 ;

select * from top_3_customer;

-- •	Find --Top 5 Customers in the month with positive influence
create view top_5_customer as
select A.customer_id,B.customer_name ,sum(case when A.transaction_type = 'credit' then A.transaction_amount else 0 end)as credit,
sum(case when A.transaction_type = 'debit' then transaction_amount else 0 end)as debit,
sum(case when A.transaction_type = 'credit' then transaction_amount else 0 end - case when A.transaction_type = 'debit' then 
transaction_amount else 0 end) as net_profit 
from transactionstable A join customertable B using (customer_id) 
where A.transaction_date <= '2023-08-30' and A.transaction_date>='2023-08-01'
group by A.customer_id , B.customer_name
order by net_profit desc limit 5 ; 

select * from top_5_customer;

create view top5_netloss_customer as
select A.customer_id,B.customer_name ,sum(case when A.transaction_type = 'credit' then A.transaction_amount else 0 end)as credit,
sum(case when A.transaction_type = 'debit' then transaction_amount else 0 end)as debit,
sum(case when A.transaction_type = 'credit' then transaction_amount else 0 end - case when A.transaction_type = 'debit' then 
transaction_amount else 0 end) as net_profit 
from transactionstable A join customertable B using (customer_id) 
where A.transaction_date <= '2023-08-30' and A.transaction_date>='2023-08-01'
group by A.customer_id , B.customer_name
order by net_profit  limit 5 ; 

select * from top5_netloss_customer ;
-- •	Insert data through SQL.
insert into transactionstable values
('501', '6', '2023-12-14', 'Credit', '145556', 'Apps', 'Naira');

insert into transactionstable values
('502', '10', '2023-12-14', 'Credit', '245556', 'Apps', 'Naira');
insert into transactionstable values
('503', '6', '2023-12-14', 'Debit', '149556', 'Web', 'Naira');
insert into transactionstable values
('504', '11', '2023-12-14', 'Credit', '145556', 'Web', 'Naira');
insert into transactionstable values
('505', '11', '2023-12-14', 'Debit', '145556', 'Cards', 'Naira');
insert into transactionstable values
('506', '13', '2023-12-14', 'Debit', '246756', 'Apps', 'Naira');
insert into transactionstable values
('507', '20', '2023-12-15', 'Credit', '315556', 'Apps', 'Naira');
insert into transactionstable values
('508', '12', '2023-12-15', 'Credit', '915556', 'Apps', 'Naira');
insert into transactionstable values
('509', '17', '2023-12-15', 'Debit', '390556', 'Apps', 'Naira');
insert into transactionstable values
('510', '17', '2023-12-15', 'Debit', '536556', 'Apps', 'Naira');
insert into transactionstable values
('511', '12', '2023-12-15', 'Credit', '205556', 'Apps', 'Naira');
insert into transactionstable values
('512', '19', '2023-12-15', 'Debit', '245556', 'Apps', 'Naira');
insert into transactionstable values
('513', '9', '2023-12-16', 'Credit', '445556', 'Apps', 'Naira');
insert into transactionstable values
('514', '10', '2023-12-16', 'Debit', '335556', 'Apps', 'Naira');
insert into transactionstable values
('515', '12', '2023-12-16', 'Debit', '144456', 'Apps', 'Naira');
insert into transactionstable values
('516', '5', '2023-12-17', 'Credit', '125556', 'Apps', 'Naira');
insert into transactionstable values
('517', '1', '2023-12-17', 'Credit', '241156', 'Apps', 'Naira');
insert into transactionstable values
('518', '3', '2023-12-17', 'Debit', '123556', 'Apps', 'Naira');
insert into transactionstable values
('519', '11', '2023-12-18', 'Debit', '145556', 'Cards', 'Naira');
insert into transactionstable values
('520', '13', '2023-12-18', 'Debit', '6756', 'Apps', 'Naira');
insert into transactionstable values
('521', '20', '2023-12-18', 'Credit', '15556', 'Apps', 'Naira');
insert into transactionstable values
('522', '12', '2023-12-18', 'Credit', '915556', 'Apps', 'Naira');
insert into transactionstable values
('523', '17', '2023-12-18', 'Debit', '390556', 'Apps', 'Naira');
insert into transactionstable values
('524', '17', '2023-12-18', 'Debit', '6556', 'Apps', 'Naira');
insert into transactionstable values
('525', '12', '2023-12-18', 'Credit', '205556', 'Apps', 'Naira');


