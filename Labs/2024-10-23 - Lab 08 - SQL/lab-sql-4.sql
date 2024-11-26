### Instructions
USE sakila;
SELECT * FROM film;

-- 1. Get film ratings.
SELECT DISTINCT(rating) FROM film;
-- 5 different ratings: PG, G, NC-17, PG-13, R

-- 2. Get release years.
SELECT DISTINCT(release_year) FROM film;
-- Only one year, 2006

-- 3. Get all films with ARMAGEDDON in the title.
SELECT * FROM film
WHERE title LIKE '%ARMAGEDDON%';
-- 6 films

-- 4. Get all films with APOLLO in the title
SELECT * FROM film
WHERE title LIKE '%APOLLO%';
-- 6 films

-- 5. Get all films which title ends with APOLLO.
SELECT * FROM film
WHERE title LIKE '%APOLLO';
-- 5 films

-- 6. Get all films with word DATE in the title.
SELECT * FROM film
WHERE title LIKE '% DATE%';
-- 4 films

-- 7. Get 10 films with the longest title.
SELECT * FROM film
ORDER BY length(title) desc
LIMIT 10;

-- 8. Get 10 the longest films.
SELECT * FROM film
ORDER BY length desc
LIMIT 10;

-- 9. How many films include **Behind the Scenes** content?
SELECT * FROM film
WHERE special_features LIKE '%Behind the Scenes%';

-- 10. List films ordered by release year and title in alphabetical order.
SELECT * FROM film
ORDER BY release_year, title;
-- all the films were released in 2006