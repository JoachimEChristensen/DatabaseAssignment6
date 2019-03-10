-- First 3 excercises are using 'classicmodels' database

/* Excercise 1
In the classicmodels database, write a query that picks out those customers who are in the same city as office of their sales representative. 
*/
select customers.* 
from customers 
left join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
left join offices on employees.officeCode = offices.officeCode
where customers.city = offices.city;

/* Excercise 2
Change the database schema so that the query from exercise get better performance. 
*/
-- SQL query will still be the same as excercise 1. What we do is ADD INDEX to some specific tables. 

/* Excercise 3
We want to find out how much each office has sold and the max single payment for each office. Write two queries which give this information.
*/
-- Using grouping
select sum(payments.amount) as 'sold for', max(payments.amount) as 'max payment', offices.city
from offices
left join employees on offices.officeCode = employees.officeCode
left join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
left join payments on customers.customerNumber = payments.customerNumber
group by offices.officeCode;

-- Using windowing (DISTINCT is use for at limit the output, so we don't get duplicate rows)
select DISTINCT offices.city,
sum(payments.amount) OVER (PARTITION BY offices.officeCode) as 'sold for',
max(payments.amount) OVER (PARTITION BY offices.officeCode) as 'max payment'
from offices
left join employees on offices.officeCode = employees.officeCode
left join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
left join payments on customers.customerNumber = payments.customerNumber;

/* Excercise 4
In the stackexchange forum for coffee (coffee.stackexchange.com), write a query which return the displayName and title of all posts which with the word grounds in the title.
*/
select users.DisplayName, posts.Title 
from posts 
left join users on posts.OwnerUserId = users.Id 
where posts.Title like '%grounds%';

-- Using userid instead of getting display name and with no join
select Id, Title 
from posts
where posts.Title like '%grounds%';

/* Excercise 5
Add a full text index to the posts table and change the query from exercise 4 so it no longer scans the entire posts table.
*/
ALTER TABLE posts 
ADD FULLTEXT(Title);

select users.DisplayName, posts.Title 
from posts 
left join users on posts.OwnerUserId = users.Id 
where match(posts.Title) against('%grounds%');