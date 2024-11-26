### Instructions
USE sakila;

#1. How many distinct (different) actors' last names are there?
SELECT * FROM actor;
SELECT count(DISTINCT last_name) FROM actor;
-- Answer: 121 distinct (different) actors' last names

#2. In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)
SELECT * FROM film;
SELECT count(DISTINCT language_id) FROM film;
-- 1 distinct language

#3. How many movies were released with `"PG-13"` rating?
SELECT COUNT(*) FROM film
WHERE rating = 'PG-13';
-- 223 movies

#4. Get 10 the longest movies from 2006.
SELECT * FROM film
WHERE release_year = '2006'
ORDER BY length desc
LIMIT 10;
-- they all last 185min

#5. How many days has been the company operating (check `DATEDIFF()` function)?
SELECT left(max(payment_date),10) FROM payment; -- 2006-02-14
SELECT left(min(payment_date),10) FROM payment; -- 2005-05-24

SELECT DISTINCT(DATEDIFF('2006-02-14', '2005-05-24')) AS DateDiff FROM payment;
-- Answer: 266 days

SELECT DISTINCT(DATEDIFF(curdate(), '2005-05-24')) AS DateDiff FROM payment;
-- Answer: 7102 days

SELECT DATEDIFF(curdate(), min(rental_date)) AS DateDiff FROM rental;
-- Answer: 7102 days

#6. Show rental info with additional columns month and weekday. Get 20.
SELECT *
, right((left(rental_date,7)),2) AS month
, weekday(rental_date) as weekday
FROM rental
LIMIT 20; -- with the months and weekdays as numbers

-- we can also convert the numbers into words
SELECT *
, right((left(rental_date,7)),2) AS month
, CASE
	WHEN weekday(rental_date) = 0 THEN 'Monday'
	WHEN weekday(rental_date) = 1 THEN 'Tuesday'
	WHEN weekday(rental_date) = 2 THEN 'Wednesday'
	WHEN weekday(rental_date) = 3 THEN 'Thursday'
	WHEN weekday(rental_date) = 4 THEN 'Friday'
	WHEN weekday(rental_date) = 5 THEN 'Saturday'
	WHEN weekday(rental_date) = 6 THEN 'Sunday'
END AS weekday
FROM rental
LIMIT 20;

#7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *
, CASE 
WHEN weekday(rental_date) in (5,6) THEN 'weekend'
ELSE 'workday'
END AS weekday
FROM rental;

#8. How many rentals were in the last month of activity?
SELECT max(extract(YEAR_MONTH from rental_date)) FROM rental;

SELECT count(*) FROM rental
WHERE rental_date > '2006-02-01';
-- Answer = 182 rentals in the last month (February 2006)