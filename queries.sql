-- BASIC QUERIES

-- View all records
select * from books;
select * from customers;
select * from orders;

-- Filter examples
select * from books where genre='Fiction';
select * from books where published_year > 1950;
select * from customers where country = 'Canada';
select * from orders where order_date between '2023-11-01' and '2023-11-30';

-- Aggregate basics
select sum(stock) as total_stock from books;
select sum(total_amount) as total_revenue from orders;
select distinct genre from books;

-- Sorting & limits
select * from books order by price desc limit 1;
select * from books order by stock limit 1;

--------------------------------------------------

-- ADVANCED / ANALYTICAL QUERIES

-- Genre-wise books sold
select b.genre, sum(o.quantity) as total_books_sold
from orders o
join books b on b.book_id=o.book_id
group by b.genre;

-- Average price of Fantasy books
select avg(price) as avg_price
from books
where genre='Fantasy';

-- Customers with 2 or more orders
select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
join customers c on o.customer_id=c.customer_id
group by o.customer_id, c.name
having count(o.order_id) >= 2;

-- Most ordered book
select o.book_id, b.title, count(o.order_id) as order_count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id, b.title
order by order_count desc
limit 1;

-- Top 3 expensive Fantasy books
select *
from books
where genre='Fantasy'
order by price desc
limit 3;

-- Author-wise books sold
select b.author, sum(o.quantity) as total_books_sold
from orders o
join books b on b.book_id=o.book_id
group by b.author;

-- Customer-wise total spending
select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id, c.name
order by total_spent desc;

-- Remaining stock calculation
select b.book_id, b.title, b.stock,
coalesce(sum(o.quantity),0) as order_qnty,
b.stock - coalesce(sum(o.quantity),0) as remaining_qnty
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id
order by b.book_id;
