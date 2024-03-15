create database music;
use music;
SELECT * from employee; 
-- Q1: Who is the senior most employee based on job title? */
SELECT levels,last_name,first_name,title from employee order by levels desc;

SELECT title, last_name, first_name 
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2: Which countries have the most Invoices? */
select count(*) as c,billing_country from invoice group by billing_country order by c desc;
select max(invoice_id) as count,billing_country from invoice group by billing_country  ;

-- Q3: What are top 3 values of total invoice? */
select count(*), total from invoice  group by total order by total desc limit 3;

-- Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals */
select * from invoice_line;
use music;
SELECT billing_city,sum(total) as sum from invoice group by billing_city order by sum desc;

-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.*/

select first_name,last_name,sum(total) as sum,customer_id from customer
join invoice using(customer_id)
group by first_name,last_name,customer_id
order by sum desc limit 1;



-- INTERMEDIATE
-- Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A. */
select distinct customer.email,first_name,last_name,genre.name from customer
join invoice using(customer_id)
join invoice_line using(invoice_id)
join track using (track_id)
join genre using(genre_id)
where genre.name="Rock" order by email asc;
-- Q2: Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select distinct genre.name,artist.name,count(artist_id) as count from track
join genre using (genre_id)
join album2 using (album_id)
join artist using(artist_id)
where genre.name="Rock" 
group by  genre.name,artist.name
order by count desc;

-- 3  Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
select distinct name,milliseconds,avg(milliseconds) from track
where milliseconds>(select avg(milliseconds) from track) group by name,milliseconds
order by milliseconds desc;


-- ADVANCE
-- Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
select customer.first_name,last_name,artist.name,invoice_line.unit_price, SUM(invoice_line.unit_price*invoice_line.quantity) AS amount_spent
 from customer
join invoice using (customer_id)
join invoice_line using (invoice_id)
join track using (track_id)
join album2 using(album_id)
join artist using(artist_id)
group by customer.first_name,last_name,artist.name,invoice_line.unit_price
order by amount_spent desc;
use music;
-- Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres. */
select count(invoice_line.quantity) as highest_purchase,customer.country,genre.name,genre_id from customer
join invoice using(customer_id)
join invoice_line using (invoice_id)
join track using (track_id)
join genre using (genre_id)
group by customer.country,genre.name,genre_id
order by highest_purchase desc;

-- Q3: Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount. */

select customer.first_name,last_name,invoice.billing_country,sum(invoice.total) as spending from customer
join invoice using(customer_id)
group by customer.first_name,last_name,invoice.billing_country
order by spending desc;
