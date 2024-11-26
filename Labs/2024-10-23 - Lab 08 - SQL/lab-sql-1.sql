-- LAB SQL 1

-- Instructions
-- 1. Use sakila database.
USE sakila;
-- 2. Get all the data from tables actor, film and customer.
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;

-- 3. Get film titles.
SELECT title FROM film;

-- 4. Get unique list of film languages under the alias language.
-- Note that we are not asking you to obtain the language per each film, but this is a good time to think about how you might get that information in the future.
SELECT * FROM language;
SELECT DISTINCT(name) FROM language;
-- Answer = 6. English, Italian, Japanese, Mandarin, French, German
-- BUT
SELECT * FROM film;
SELECT * FROM film WHERE language_id='1';
SELECT * FROM film WHERE language_id='2';
-- 1.000 movies in English, none in the other languages

-- 5.1 Find out how many stores does the company have?
SELECT * FROM store;
-- Answer = 2

-- 5.2 Find out how many employees staff does the company have?
SELECT * FROM staff;
-- Answer = 2, one in each store

-- 5.3 Return a list of employee first names only?
SELECT first_name FROM staff;

-- 6. Select all the actors with the first name ‘Scarlett’.
SELECT * FROM actor WHERE first_name='Scarlett';

-- 7. Select all the actors with the last name ‘Johansson’.
SELECT * FROM actor WHERE last_name='Johansson';

-- 8. How many films (movies) are available for rent?
SELECT count(DISTINCT(title)) FROM film;
-- Answer: 1000

-- 9. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT * FROM film
ORDER BY length desc LIMIT 1;
-- If we do this, then: Longest movie: Chicago North (185min)
-- BUT in fact there are many movies with the same duration
SELECT * FROM film
WHERE length = (SELECT max(length) FROM film);
-- 'Chicago North' is just the first one that appears alphabetically

SELECT * FROM film
ORDER BY length LIMIT 1;
-- If we do this, then: Shortest movie: Alien Center (46min)
-- BUT in fact there are many movies with the same duration
SELECT * FROM film
WHERE length = (SELECT min(length) FROM film);
-- 'Alien Center' is just the first one that appears alphabetically

-- 10. What's the average movie duration?
SELECT AVG(length) FROM film;
SELECT 0.2720*60;
-- Average length: 1h, 55min and 16sec

-- 11. How many movies are longer than 3 hours?
SELECT COUNT(*) FROM film WHERE length > 180;
-- Answer = 39

-- 12. What's the length of the longest film title?
SELECT length(title) FROM film
ORDER BY length(title) desc LIMIT 1;
-- Answer = 27 characters
