### Instructions
USE sakila;

-- 1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
SELECT title
	, length
    , RANK() OVER(ORDER BY length DESC) AS 'rank'
	, DENSE_RANK() OVER(ORDER BY length DESC) AS 'dense_rank'
FROM film;
    
-- 2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column).
-- In your output, only select the columns title, length, rating and rank. 
SELECT title
	, length
    , rating
    , RANK() OVER(PARTITION BY rating ORDER BY length DESC) AS 'rank'
FROM film;
 
-- 3. How many films are there for each of the categories in the category table? **Hint**: Use appropriate join between the tables "category" and "film_category".
-- como Bernardo:
SELECT name
	, COUNT(*) AS movie_count
FROM film_category AS film
LEFT JOIN category AS cat -- porqué un LEFT JOIN y no un simple (INNER) JOIN?
ON cat.category_id = film.category_id
GROUP BY name
ORDER BY movie_count DESC;
 
-- a mi manera
SELECT DISTINCT(name)
	, COUNT(name) OVER(PARTITION BY name) AS movie_count
FROM film_category AS film
LEFT JOIN category AS cat
ON cat.category_id = film.category_id
ORDER BY movie_count DESC;

-- 4. Which actor has appeared in the most films? **Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
SELECT first_name
	, last_name
	, COUNT(*) AS count
FROM film_actor
JOIN actor
ON film_actor.actor_id = actor.actor_id 
GROUP BY first_name, last_name 
-- parece que da un resultado correcto, pero en realidad no, porque pueden haber dos actores con el mismo nombre y apellidos 
ORDER BY count DESC
; -- aquí Susan Davis es la actriz que actúa en más pelis, 54

SELECT * FROM actor
WHERE last_name = 'Davis'; -- aquí vemos que hay 2 'Susan Davis'

SELECT first_name
	, last_name
	, count(*) AS count
FROM actor
GROUP BY first_name, last_name
ORDER BY count DESC; -- aquí lo podemos comprobar bien

-- bien hecho:
SELECT first_name
		, last_name
		, count
FROM
    (
	SELECT actor.actor_id
		, first_name
		, last_name
		, COUNT(*) AS count
	FROM film_actor
	JOIN actor
	ON film_actor.actor_id = actor.actor_id 
	GROUP BY actor_id -- agrupando por actor_id, el cual es único
	ORDER BY count DESC
	) actors
LIMIT 1
; -- Gina Degeneres ha actuado en 42 películas

-- 5. Which is the most active customer (the customer that has rented the most number of films)? 
-- **Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.
SELECT first_name, last_name, rentals FROM
	(
    SELECT customer.customer_id
		, first_name
		, last_name
		, COUNT(*) AS rentals
	FROM rental
	JOIN customer
	ON rental.customer_id = customer.customer_id
	GROUP BY customer_id
    ORDER BY rentals DESC
    ) sub1
LIMIT 1
; -- Eleanor Hunt, 46 rentals

-- 6. List the number of films per category.
SELECT category.name
	, film.title
FROM film_category
LEFT JOIN category
ON film_category.category_id = category.category_id
LEFT JOIN film
ON film_category.film_id = film.film_id
ORDER BY category.category_id
;

-- 7. Display the first and the last names, as well as the address, of each staff member.
SELECT first_name
	, last_name
    , address
FROM staff
JOIN address
ON staff.address_id = address.address_id
;

-- 8. Display the total amount rung up by each staff member in August 2005.
SELECT first_name
	, last_name
    , SUM(amount) AS earnings
FROM staff 
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY first_name, last_name
; 
-- Mike Hillyer: 33.482,50 $
-- Jon Stephens: 33.924,06 $

-- 9. List all films and the number of actors who are listed for each film.
SELECT title
	, COUNT(actor_id)
FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title
; -- Max: Academy Dinosaur (10 actors)

-- 10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer.
-- List the customers alphabetically by their last names.
SELECT first_name
	, last_name
    , SUM(amount) AS payment
FROM payment
JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY first_name, last_name
ORDER BY last_name
;

-- 11. Write a query to display for each store its store ID, city, and country.
SELECT store_id
	, city
    , country
FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
;
-- 1: Lethbridge, Canada
-- 2: Woodridge, Australia

-- 12. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id
	, SUM(amount) as earnings
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
JOIN store
ON store.store_id = staff.store_id
GROUP BY store_id
; -- los mismos resultados que la pregunta 8, ya que cada tienda solo tiene un staff member.
-- Store 1: 33.482,50 $
-- Store 2: 33.924,06 $

-- 13. What is the average running time of films by category?
SELECT name
	, AVG(length) AS avg_length
FROM film
JOIN film_category
ON film.film_id = film_category.film_id
JOIN category
ON film_category.category_id = category.category_id
GROUP BY name
;

-- 14. Which film categories are longest?
-- La misma query de antes, con un ORDER BY length DESC
SELECT name
	, AVG(length) AS avg_length
FROM film
JOIN film_category
ON film.film_id = film_category.film_id
JOIN category
ON film_category.category_id = category.category_id
GROUP BY name
ORDER BY avg_length DESC
LIMIT 4; -- Sports, Games, Foreign and Drama

-- 15. Display the most frequently rented movies in descending order.
SELECT title
	, COUNT(*) AS count
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
GROUP BY title
ORDER BY count DESC
; -- Bucket Brotherhood, 34

-- 16. List the top five genres in gross revenue in descending order.
SELECT name
	, SUM(amount) AS sales
FROM payment
JOIN rental
ON payment.rental_id = rental.rental_id
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
JOIN film_category
ON film_category.film_id = film.film_id
JOIN category
ON film_category.category_id = category.category_id
GROUP BY name
ORDER BY sales DESC
LIMIT 5
; -- Sports, Sci-Fi, Animation, Drama and Comedy

-- 17. Is "Academy Dinosaur" available for rent from Store 1?
-- por separado: primero conseguimos el film_id
SELECT film_id
FROM film
WHERE title = 'Academy Dinosaur'; -- film_id = 1
-- luego aplicamos el film_id al WHERE para conseguir la store
SELECT DISTINCT(store_id)
FROM inventory
WHERE film_id = 1; -- yes, it's available in both stores

-- todo junto con una subquery
SELECT DISTINCT(store_id)
FROM inventory
WHERE film_id IN
	(
	SELECT film_id
	FROM film
	WHERE title = 'Academy Dinosaur'
	)
; -- yes, it's available in both stores
