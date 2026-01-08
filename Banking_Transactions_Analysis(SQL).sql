use bank;

#1.Total number of customers
select Count(Customer_ID)
from customers;

#2.List distinct city where customers are belong
select distinct(City)
from customers;

#3.find Total sucess transaction amount

Select Sum(Amount) as "Amount"
from transactions
where status = "Success";

#4.Count transactions by transaction type

select transaction_type, Count(Transaction_ID) as "Count"
from transactions
group by transaction_type;

#5.No of customer by account type

select Account_Type, count(Customer_ID) as "count"
from customers
group by Account_Type;

#Total Transaction amount by Customer
select customers.Customer_ID,Name, Sum(Amount)
from customers
inner join transactions
on customers.Customer_ID = transactions.Customer_ID
group by customers.Customer_ID,customers.Name;

#Top 5 customers by Transasction
select customers.Customer_ID, Name, Sum(Amount) as "Total"
from customers
inner join transactions
on customers.Customer_ID = transactions.Customer_ID
group by customers.Customer_ID, customers.Name
order by Total DESC
limit 5;

#Customers who never make transaction

select customers.Customer_ID, Name
from customers
left join transactions
on customers.Customer_ID = transactions.Customer_ID
where transactions.Transaction_ID is NULL;

#Avg Transactions by channel
select Channel, Avg(Amount) as "Avg Amount"
from transactions
group by Channel;

#Sub Query Questions
#Customers loan greater than avg loan

Select customers.Customer_ID, Name
from customers
inner join loan
on customers.Customer_ID = loan.Customer_ID
where Loan_Amount > (Select Avg(Loan_Amount) from loan);

#Find customers whose total transaction amount is greater- 
#-than the average total transaction amount of all customers

Select customers.Customer_ID ,Name,Sum(Amount) as "Total"
from customers
inner join transactions
on customers.Customer_ID = transactions.Customer_ID
group by customers.Customer_ID,Name
having Total > (Select avg(Amount) from transactions);

#customers who never take a loan

select Count(Customer_ID)
from customers
where Customer_ID Not In (select Customer_Id from loan);

#Total number of success transactions whose amount i greater tha avg transaction Amount

select Count(Transaction_Id)
from transactions
where Status = "Success" and Amount > (Select avg(Amount) from transactions)
;

#Windows Function
#Find the latest transaction for each customer

SELECT Customer_ID, Transaction_ID, Date, Amount
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Customer_ID
               ORDER BY Date DESC
           ) AS rn
    FROM transactions
) t
WHERE rn = 1;

#Top transaction by each Customer
SELECT Customer_ID, Transaction_ID, Amount
FROM (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY Customer_ID
               ORDER BY Amount DESC
           ) AS rnk
    FROM transactions
) t
WHERE rnk = 1;




