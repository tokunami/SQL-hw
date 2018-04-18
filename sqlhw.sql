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
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

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
select distinct last_name, count(*) from actor group by last_name having count(*) > 1;
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor set first_name=replace(first_name, 'GROUCHO', 'HARPO') where last_name='williams';
select * from actor where first_name = 'harpo' or first_name = 'groucho';
update actor set first_name=replace(first_name, 'HARPO', 'GROUCHO') where last_name='williams';
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
select first_name, last_name, address from address inner join staff on address.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- both work 
select first_name, last_name, sum(amount) from payment inner join staff on payment.staff_id = staff.staff_id where payment_date between '2005-07-31 23:59:59' and '2005-09-01 00:00:00' group by staff.staff_id;
select first_name, last_name, sum(amount) from staff inner join payment on staff.staff_id = payment.staff_id where payment_date between '2005-07-31 23:59:59' and '2005-09-01 00:00:00' group by payment.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, count(*) as 'actors count' from film_actor inner join film on film_actor.film_id = film.film_id group by film.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
-- 
-- 
--     ![Total amount paid](Images/total_payment.png)
-- 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
-- 7e. Display the most frequently rented movies in descending order.
-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- 7g. Write a query to display for each store its store ID, city, and country.
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
-- 8b. How would you display the view that you created in 8a?
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.