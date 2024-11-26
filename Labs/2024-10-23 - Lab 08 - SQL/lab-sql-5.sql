### Instructions
USE sakila;
DESC film;

-- 1. In the table actor, which are the actors whose last names are not repeated?
-- For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd.
-- These three actors have the same last name. So we do not want to include this last name in our output.
-- Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list. 
SELECT count(*) FROM actor;
-- 200 actors
SELECT count(DISTINCT(last_name)) FROM actor;
-- 121 distinct last_name

SELECT last_name AS name FROM actor
GROUP BY last_name
HAVING (COUNT((last_name)) = 1)
ORDER BY last_name;

SELECT first_name, last_name AS name FROM actor
GROUP BY first_name, last_name
HAVING (COUNT((last_name)) = 1)
ORDER BY last_name;

-- how to count the results? 2 options
-- We can also look at the Output panel

-- Option 1:
SELECT COUNT(*) from(
SELECT last_name AS name FROM actor
GROUP BY last_name
HAVING (COUNT((last_name)) = 1)
ORDER BY last_name
) as subquery; -- 66 actors whose last names are not repeated

-- Option 2:
with subquery as (
SELECT last_name AS name FROM actor
GROUP BY last_name
HAVING (COUNT((last_name)) = 1)
ORDER BY last_name
)
SELECT COUNT(*) from subquery
;  -- 66 actors whose last names are not repeated

-- 2. Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
SELECT last_name FROM actor
GROUP BY last_name
HAVING (COUNT((last_name)) > 1)
ORDER BY last_name;

SELECT COUNT(*) FROM (
SELECT last_name FROM actor
GROUP BY last_name
HAVING (COUNT((last_name)) > 1)
ORDER BY last_name
) as subquery; -- 55 actors whose last names appear more than once

select 55 + 66 as actors_count; -- 121 actors in total, correct

-- 3. Using the rental table, find out how many rentals were processed by each employee.
SELECT DISTINCT(staff_id) FROM rental; -- 2 staff members
SELECT COUNT(*) FROM rental WHERE staff_id = 1; -- 8040
SELECT COUNT(*) FROM rental WHERE staff_id = 2; -- 8004

-- 4. Using the film table, find out how many films were released each year.
SELECT COUNT(*) FROM film WHERE release_year = 2006;
-- 1000 films released in only one year, 2006

-- 5. Using the film table, find out for each rating how many films were there.
SELECT DISTINCT(rating) FROM film;
-- 5 different ratings: PG, G, NC-17, PG-13, R
SELECT COUNT(*) FROM film WHERE rating = 'PG'; -- 194
SELECT COUNT(*) FROM film WHERE rating = 'G'; -- 178
SELECT COUNT(*) FROM film WHERE rating = 'NC-17'; -- 210
SELECT COUNT(*) FROM film WHERE rating = 'PG-13'; -- 223
SELECT COUNT(*) FROM film WHERE rating = 'R'; -- 195

-- much easier and faster
SELECT rating, COUNT(*) FROM film 
GROUP BY rating; -- 194, 178, 210, 223, 195

-- 6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places 
SELECT rating, round(AVG(length),2) AS mean FROM film
GROUP BY rating;
/* Results
'PG'; -- 112.01
'G'; -- 111.05
'NC-17'; -- 113.23
'PG-13'; -- 120.44
'R'; -- 118.66
*/

-- 7. Which kind of movies (rating) have a mean duration of more than two hours?
SELECT rating, round(AVG(length),2) AS mean FROM film
GROUP BY rating
HAVING avg(length) > 120;
-- Answer: PG-13 (120.44 min on avg)