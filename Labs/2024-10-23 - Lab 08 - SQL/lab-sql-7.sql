### Instructions
USE sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT copies FROM
	(
    SELECT film_id
		, COUNT(*) AS copies
	FROM inventory
	WHERE film_id = 
		(
		SELECT film_id
		FROM film
		WHERE title = "Hunchback Impossible"
        ) -- film_id = 439
	GROUP BY film_id
    ) sub1
; -- 6 copies

-- 2. List all films whose length is longer than the average of all the films.
SELECT title
	, length 
FROM
	(
	SELECT title
		, length
		, AVG(length) OVER() AS avg_length -- = 115,272 min
	FROM film
    ) average
WHERE length > avg_length
;

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT actor.actor_id
	, first_name
    , last_name
FROM film_actor
JOIN actor
ON film_actor.actor_id = actor.actor_id
WHERE film_id = 
	(
    SELECT film_id
	FROM film
	WHERE title = 'Alone Trip' -- 17
    )
GROUP BY actor_id
; -- 8 actors

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

-- with a subquery
SELECT title
FROM film
WHERE film_id in
	(
    SELECT film_id
    FROM film_category
    WHERE category_id =
		(
		SELECT category_id
		FROM category
		WHERE name = 'Family'
		)
	)
;

-- same thing with a Join
SELECT title
FROM film
JOIN film_category
ON film.film_id = film_category.film_id
    WHERE category_id =
		(
		SELECT category_id
		FROM category
		WHERE name = 'Family'
		)
;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.

-- with subqueries
SELECT first_name
	, last_name
	, email
FROM customer
WHERE customer_id IN
	(
	SELECT customer_id
	FROM customer
	WHERE address_id IN
		(
		SELECT address_id
		FROM address
		WHERE city_id IN
			(
			SELECT city_id
			FROM city
			WHERE country_id =
				(
				SELECT country_id
				FROM country
				WHERE country = 'Canada'
				)
			)
		)
	)
;

-- with Joins
SELECT first_name
	, last_name
	, email
FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
WHERE country.country_id = 
	(
	SELECT country_id
	FROM country
	WHERE country = 'Canada'
	)
;

-- 6. Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- with subqueries
-- recuperamos una query del anterior lab
SELECT title
FROM film
WHERE film_id IN 
	(
    SELECT film_id
    FROM film_actor
	WHERE actor_id =
		(
		SELECT actor_id -- 107
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
		)
	)
;

-- same thing with a Join
SELECT title
FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id
WHERE actor_id =
		(
		SELECT actor_id -- 107
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
		)
;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer,
-- ie the customer that has made the largest sum of payments
SELECT title
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
JOIN customer
ON payment.customer_id = customer.customer_id
WHERE customer.customer_id = 
	(
	SELECT customer.customer_id
	FROM
		(
		SELECT customer.customer_id
			, first_name
			, last_name
			, SUM(amount) AS payment
		FROM payment
		JOIN customer
		ON payment.customer_id = customer.customer_id
		GROUP BY customer_id, first_name, last_name
		ORDER BY payment DESC
		LIMIT 1 -- 526 Karl Seal $221.55
		) customer
	)
;

-- 8. Get the `client_id` and the `total_amount_spent` of those clients
-- who spent more than the average of the `total_amount` spent by each client.

SELECT customer_id
	, client_amount
FROM 
	(
	SELECT customer_id
		, SUM(amount) AS client_amount
		, AVG(SUM(amount)) OVER() AS avg_amount -- = $112.53
	FROM payment
	GROUP BY customer_id
	) amount
WHERE client_amount > avg_amount
;













