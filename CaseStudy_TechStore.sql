/* This case study delves into the database of a tech store (devices, employees, purchases, customers, etc.)
and extracts some insightful information about the customers, salespersons and popular devices. */

/* Allowing the option of manipulating data */
set sql_safe_updates = 0;

/* creating the tables; if it's already commited to a schema, it should be dropped first*/
-- Creating tables of customers, products, product types, purchases and store staff
drop table if exists customers, products, product_types, original_purchases, employees;
create table customers(
	cust_id int NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    dob date,
    phone_number char(12) UNIQUE,
    gender varchar(10),
    primary key (cust_id)
);
create table products(
	product_id int NOT NULL,
	product_type_id int NOT NULL
		references product_types(product_type_id),
    product_name varchar(40) NOT NULL,
    product_desc varchar(100),  -- description of a product
    price decimal(7, 2),
    primary key (product_id)
);
create table product_types(
	product_type_id int NOT NULL,
    type_name varchar(20) NOT NULL,
    primary key (product_type_id)
);
create table original_purchases(
    cust_id int NOT NULL
		references customers(customer_id),
	product_id int NOT NULL
		references products(product_id),
    quantity tinyint unsigned default 1,
	salesperson_id int NOT NULL
		references employees(employee_id),
    primary key (cust_id, product_id)
);
create table employees(
    employee_id int NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
    `role` varchar(15) NOT NULL,
    supervisor_id int,  -- the employee ID of an employee's supervisor
    primary key (employee_id)
);

/* Adding information (new rows) into customers table */
insert into customers (cust_id, first_name, last_name, dob, phone_number, gender) 
	values (1, 'Joe', 'Stevens', '1984-12-11', '231-564-9010', 'Male');
insert into customers values (2, 'Chelsea', 'McIntyre', '92-6-22', '442-231-1980', 'Female');
insert into customers values (3, 'Peter', 'Coleman', '1982-8-14', '225-119-8671', 'Male');
insert into customers values (4, 'David', 'Sweany', '1982-8-14', '225-119-9130', 'Male');
insert into customers values (5, 'Andrea', 'Thompson', '1990-05-23', '745-101-6512', 'Female');
insert into customers values (6, 'Patrick', 'Bateman', '1972-11-15', '808-444-4213', 'Male');
insert into customers values (7, 'Nancy', 'Gutierrez', '1988-11-15', '565-723-7981', 'Female');

/* Adding information into products table */
insert into products (product_id, product_type_id, product_name, product_desc, price) 
	values (1, 1, 'iPhone 13', '5G, 128GB, 6.1 inches', 829.00);
insert into products values (2, 2, 'iPad Pro 5th gen', '4G, 1TB, 8GB RAM, 24.16 oz', 1279.99);
insert into products values (3, 1, 'Samsung Galaxy S22 Ultra', '5G, 40MP Front Camera, 512GB, 14 inches HD', 1199.99);
insert into products values (4, 3, 'Dell XPS 15', ' i5-12500H (12 cores), 32GB RAM, 2TB SSD, 15.6 inches', 1609.00);
insert into products values (5, 1, 'iPhone 14 Pro Max', '5G, 48MP Main Camera, 256GB, 6.7 inches', 829.00);
insert into products values (6, 3, 'Lenovo ThinkPad X1', 'Windows 10, 8GB RAM, 256GB SSD, 14 inches', 1352.45);
insert into products values (7, 4, 'Apple iMac', 'Intel Corei7, 512GB SSD, 8GB RAM, 27 inches', 2299.99);
insert into products values (8, 2, 'Surface Pro 8', 'Intel Corei5, 128GB SSD, 8GB RAM', 1099.99);
insert into products values (9, 1, 'Google Pixel 7 Pro', '4G/5G, 128GB, 50MP wide lens, 6.7 inches QHD', 829.00);
insert into products values (10, 4, 'Dell OptiPlex 7400', 'i5-12500, 256GB SSD, 16GB RAM, 23.8 inches', 2057.85);

/* Defining  product types */
insert into product_types (product_type_id, type_name) values (1, 'Phone');
insert into product_types (product_type_id, type_name) values (2, 'Tablet');
insert into product_types (product_type_id, type_name) values (3, 'Laptop');
insert into product_types (product_type_id, type_name) values (4, 'PC');

/* Adding information into the purchases table */
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (1, 10, 2, 105);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (2, 4, 1, 105);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (2, 5, 2, 103);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (3, 7, 1, 104);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (4, 6, 1, 103);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (5, 9, 1, 103);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (5, 8, 1, 105);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (5, 1, 2, 104);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (6, 7, 1, 103);
insert into original_purchases (cust_id, product_id, quantity, salesperson_id) values (7, 2, 3, 105);

/* Dumping information into the employees table */
insert into employees (employee_id, first_name, last_name, `role`, supervisor_id)
		values (101, 'Akash', 'Anand', 'CEO', NULL);
insert into employees values (102, 'Rob', 'Swanson', 'Store Manager', 101);
insert into employees values (103, 'Stefani', 'Jimenez', 'Salesperson', 102);
insert into employees values (104, 'Jack', 'Doherty', 'Salesperson', 102);
insert into employees values (105, 'Kevin', 'Booker', 'Salesperson', 102);

/* Commiting the transactions (changes) */
commit;

/* Additional purchase list: A new purchase list has come to attention, 
that might have overlap with the original purchase list */ 
drop table if exists additional_purchases;
create table additional_purchases(
    cust_id int NOT NULL
		references customers(customer_id),
	product_id int NOT NULL
		references products(product_id),
    quantity tinyint unsigned default 1,
	salesperson_id int NOT NULL
		references employees(employee_id),
    primary key (cust_id, product_id)
);
insert into additional_purchases (cust_id, product_id, quantity, salesperson_id) values (3, 8, 1, 104);
insert into additional_purchases values (1, 10, 2, 105);
insert into additional_purchases values (6, 3, 2, 104);
insert into additional_purchases values (7, 2, 3, 105);
insert into additional_purchases (cust_id, product_id, salesperson_id) values (4, 9, 103);
insert into additional_purchases values (3, 1, 2, 105);

/* Concatenating the two purchase lists */
-- Note that union must be used (not union all), since two tables have common rows.
drop table if exists purchases;
create table purchases(
	select * from original_purchases
    union
    select * from additional_purchases
    order by cust_id
);
select * from purchases;

/* Demonstrating the tables */
select * from customers;
select * from products;
select * from product_types;
select * from purchases;
select count(distinct(product_id)) from purchases; -- printing the count of unique purchased products

/* Demonstrating the type of products in the products table as well */
select prod.product_id, prod.product_type_id, prod_type.type_name, prod.product_name, prod.product_desc, prod.price
from products prod left outer join product_types prod_type
on prod.product_type_id = prod_type.product_type_id;
-- Note: Equivalently, we could do:
select prod.product_id, prod.product_type_id, prod_type.type_name, prod.product_name, prod.product_desc, prod.price
from products prod, product_types prod_type
where prod.product_type_id = prod_type.product_type_id;

/* Demonstrating the purchase list with the names of customers and products only for female customers */
select cust.cust_id, cust.first_name, cust.last_name, prod.product_name, pur.quantity
from  customers cust inner join purchases pur
on pur.cust_id = cust.cust_id and cust.gender = 'Female'
left join products prod 
on pur.product_id = prod.product_id;

/* Statistical functions on various tables */
# 1) Finding the total purchases of all customers and showing it with their names
drop table if exists cust_sum_purchase;
create table cust_sum_purchase (
	select cust_id, sum(quantity) total_purchases from purchases 
	group by cust_id order by cust_id
); -- making a table of total purchases of all customers
select sum_pur.cust_id, cust.first_name, cust.last_name, sum_pur.total_purchases
from cust_sum_purchase sum_pur left outer join customers cust
on sum_pur.cust_id = cust.cust_id;

# 2) Finding the average prices of available device types
drop table if exists device_mean_price;
create table device_mean_price (
	select product_type_id, avg(price) average_price from products 
	group by product_type_id order by product_type_id
); -- making a table of average price of each device type (phone, tablet, etc.)
select dev_price.product_type_id, prod_types.type_name, dev_price.average_price
from device_mean_price dev_price left outer join product_types prod_types
on dev_price.product_type_id = prod_types.product_type_id; -- adding the type name

# 3) Finding the most expensive device for each device type
drop table if exists max_prices;
create table max_prices (
	select product_type_id, max(price) max_price from products 
	group by product_type_id order by product_type_id
); -- making a table of most expensive items of each device category
drop table if exists expensive_items;
create table expensive_items (
	select prod_types.product_type_id, prod_types.type_name, prod.product_name, prices.max_price
    from product_types prod_types left outer join max_prices prices 
	on prod_types.product_type_id = prices.product_type_id
    left outer join products prod
    on prices.max_price = prod.price 
); -- adding the type names and the name of the most expensive device to the previous table
select * from expensive_items;

# 4) Finding the final invoice of each customer
drop table if exists priced_cust_purchases;
create table priced_cust_purchases (
	select pur.cust_id,  prod.product_id, prod.price, pur.quantity
	from purchases pur left outer join products prod 
	on pur.product_id = prod.product_id
); -- making a table of all purchases of all customers with prices mentioned
 -- adding a column containing the money spent by each customer on each purchase
alter table priced_cust_purchases add column charge decimal(7, 2);  -- charge = price * quantity
update priced_cust_purchases set charge = quantity*price;
-- dropping the unnecessary column
alter table priced_cust_purchases drop column product_id;
drop table if exists final_invoice;
create table final_invoice(
	select cust_id, sum(charge) full_charge from priced_cust_purchases
    group by cust_id order by cust_id
); -- making a table of 
drop table if exists cust_final_invoice;
create table cust_final_invoice(
	select invoice.cust_id, cust.first_name, cust.last_name, cust.gender, invoice.full_charge
    from final_invoice invoice left outer join customers cust
    on invoice.cust_id = cust.cust_id
); -- creating a table containing the entire money spent by each customer
select * from cust_final_invoice;

# 5) Finding the average money spent on products by each gender
select gender, avg(full_charge) from cust_final_invoice 
group by gender order by avg(full_charge) desc;  -- showing the average invoce of men and women sorted descendingly

# 6) Finding a list of customers who have purchased more than two items 
drop table if exists named_sum_purchases;
create table named_sum_purchases( 
	select sum_pur.cust_id, cust.first_name, cust.last_name, sum_pur.total_purchases
    from cust_sum_purchase sum_pur left join customers cust
    on sum_pur.cust_id = cust.cust_id
); -- creating a table containing the ID and name of customers along with their total purchases
select first_name, last_name from named_sum_purchases where total_purchases > 2;

# 7) Finding a list of customers who have bought more than one kind of product (products with different product_id) 
drop table if exists named_purchases;
create table named_purchases( 
	select pur.cust_id, cust.first_name, cust.last_name, pur.product_id
    from purchases pur left join customers cust
    on pur.cust_id = cust.cust_id
); -- adding the name of customerss to the purchase list
-- Note: counting the repitition of an attribute (ID, name, etc.) requires group by
select first_name, last_name from named_purchases group by cust_id having count(cust_id) > 1;

/* Demonstrating supervisor's name in the employees table  (example of self-join) */
select e.employee_id, e.first_name, e.last_name, e.`role`, concat(m.first_name, ' ', m.last_name) supervisor
from employees e left join employees m
on e.supervisor_id = m.employee_id;

/* Sorting salesmen based on the number of items they've sold */
drop table if exists employees_sales;
create table employees_sales(
	select p.salesperson_id, concat(e.first_name, ' ', e.last_name) salesperson, p.product_id, p.quantity
	from purchases p left join employees e
	on p.salesperson_id = e.employee_id 
    order by salesperson_id
);
select salesperson, sum(quantity) no_of_sold_items from employees_sales
group by (salesperson_id) order by no_of_sold_items desc;

/* Sorting salesmen based on money generated by them */
drop table if exists employees_sales_in_USD;
create table employees_sales_in_USD(
	select es.salesperson_id, es.salesperson, es.quantity, p.price, es.quantity*p.price charge 
	from employees_sales es left join products p
	on es.product_id = p.product_id 
);
select salesperson, sum(charge) total_dollar_sales from employees_sales_in_USD
group by (salesperson_id) order by total_dollar_sales desc;