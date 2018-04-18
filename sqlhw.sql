use sakila;

-- 1a. Display the first and last names of all actors from the table actor. 
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%li%' order by last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');


-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
alter table actor add middle_name varchar(45) default null after first_name;
desc actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
alter table actor modify middle_name blob;
desc actor;

-- 3c. Now delete the middle_name column.
alter table actor drop middle_name;
desc actor;


-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select distinct last_name, count(*)
from actor
group by last_name
having count(*) > 1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
-- 1.regenerate HARPO WILLIAMS
update actor set first_name=replace(first_name, 'GROUCHO', 'HARPO') where last_name='williams';
-- then confirm it
select * from actor where first_name = 'harpo' or first_name = 'groucho';
-- 2.replace HARPO to GROUCHO
update actor set first_name=replace(first_name, 'HARPO', 'GROUCHO') where last_name='williams';
-- then confirm it
select * from actor where first_name = 'harpo' or first_name = 'groucho';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
update actor set first_name=replace(first_name, 'GROUCHO', 'HARPO'), first_name=replace(first_name, 'HARPO', 'MUCHO GROUCHO') where last_name='williams';
select * from actor where first_name = 'harpo' or first_name = 'groucho' or last_name='williams';

-- update actor set first_name = 'GROUCHO' where first_name = 'harpo' and last_name='williams';
update actor set first_name=replace(first_name, 'MUCHO GROUCHO', 'GROUCHO'), first_name=replace(first_name, 'HARPO', 'GROUCHO') where last_name='williams';
select * from actor where first_name = 'harpo' or first_name = 'groucho' or last_name='williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
describe sakila.address;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address
from address
inner join staff
	on address.address_id=staff.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- ** it works either way **
select first_name, last_name, sum(amount)
from payment
inner join staff
	on payment.staff_id = staff.staff_id
where payment_date
between '2005-07-31 23:59:59' and '2005-09-01 00:00:00'
group by staff.staff_id;
-- ** another way **--
select first_name, last_name, sum(amount)
from staff
inner join payment
	on staff.staff_id = payment.staff_id
where payment_date
between '2005-07-31 23:59:59' and '2005-09-01 00:00:00'
group by payment.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, count(*) as 'actors count'
from film_actor
inner join film
	on film_actor.film_id = film.film_id
group by film.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(*) as 'inventory count'
from inventory
inner join film
	on film.film_id = inventory.film_id
where title = 'Hunchback Impossible'
group by inventory.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name, sum(amount) as 'total paid'
from payment
inner join customer
	on payment.customer_id=customer.customer_id
group by customer.customer_id
order by customer.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
select title, name as 'language'
from film
inner join language
	on film.language_id=language.language_id
where (title like 'k%' or title like 'q%' ) and language.name='English';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor where actor_id in (
	select actor_id from film_actor where film_id = (
		select film_id from film where title='Alone Trip'
	)
);
-- ** just tried to use inner join **
select first_name, last_name
from actor
inner join film_actor
	on actor.actor_id = film_actor.actor_id
inner join film
	on film_actor.film_id=film.film_id
where film.title='Alone Trip';

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, email, country
from customer
inner join address
	on customer.address_id = address.address_id
inner join city
	on address.city_id=city.city_id
inner join country
	on city.country_id=city.country_id
where country.country_id='Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
select * from film
inner join film_category
	on film.film_id=film_category.film_id
inner join category
	on film_category.category_id=category.category_id
where category.name='Family';

-- 7e. Display the most frequently rented movies in descending order.
select film.title, count(*) as 'rental_count'
from rental
inner join inventory
	on rental.inventory_id=inventory.inventory_id
inner join film
	on inventory.film_id = film.film_id
group by film.film_id
order by rental_count desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(payment.amount) as 'total_amount'
from inventory
inner join rental
	on inventory.inventory_id=rental.inventory_id
inner join payment
	on rental.rental_id=payment.rental_id
group by inventory.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store
inner join address
	on store.address_id=address.address_id
inner join city
	on address.city_id=city.city_id
inner join country
	on city.country_id=country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(payment.amount) as 'gross_revenue'
from category
inner join film_category
	on category.category_id=film_category.category_id
inner join inventory
	on film_category.film_id=inventory.film_id
inner join rental
	on inventory.inventory_id=rental.inventory_id
inner join payment
	on rental.rental_id = payment.rental_id
group by category.category_id
order by gross_revenue desc
limit 0,5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create or replace view top5_genres
as
select name, sum(payment.amount) as 'gross_revenue'
from category
inner join film_category
	on category.category_id=film_category.category_id
inner join inventory
	on film_category.film_id=inventory.film_id
inner join rental
	on inventory.inventory_id=rental.inventory_id
inner join payment
	on rental.rental_id = payment.rental_id
group by category.category_id
order by gross_revenue desc
limit 0,5;

-- 8b. How would you display the view that you created in 8a?
select * from top5_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view if exists top5_genres;