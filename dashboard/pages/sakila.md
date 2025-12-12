---
title: Sakila Database Analysis
---

<Details title = 'Details of the project'>
This dashboard presents an exploratory data analysis of the Sakila database, which is a sample database provided by MySQL that represents a DVD rental store. It includes tables for films, actors, customers, rentals, and payments, among others. The analysis focuses on the film table to extract insights about movie lengths, titles, rental prices, top actor movie counts, genre distributions, and revenue trends. Various SQL queries are executed to retrieve relevant data, which is then visualized using bar charts and data tables to facilitate understanding of the dataset's characteristics and trends.
</Details>

# Task 1 A: Which movies are longer than 180 minutes?

```sql film_180
SELECT
  title,
  length
FROM film
WHERE length > 180
ORDER BY length DESC, title ASC;
```
<DataTable
  data={film_180}
  title="Movies Longer than 180 Minutes"
  rowsPerPage={8}
  search={true}
/>

# Task 1 B: Which movies have the word "love" in the title?

```sql film_love
SELECT
    title,
    rating,
    length,
    description
FROM 
    film
WHERE
    title ILIKE 'love %'
    OR title ILIKE '% love'
ORDER BY title ASC;
```
   
# Task 1 C: Calculate descriptive statistics. 
The shortest, average, median and longest movie length on the length column.

```sql film_stats
SELECT
    MIN(length) AS shortest,
    AVG(length) AS average,
    MEDIAN(length) AS median,
    MAX(length) AS longest
FROM film;
```

## EXTRA EDA 1: Which runtime category monetizes best?

```sql runtime_revenue
WITH film_band AS (
    SELECT f.film_id, f.title, f.length,
        CASE
            WHEN f.length < 90 THEN 'Short'
            WHEN f.length BETWEEN 90 AND 150 THEN 'Medium'
            ELSE 'Long'
        END AS length_band
    FROM sakila.film f),

revenue AS (
    SELECT
        fb.length_band,
        COUNT(DISTINCT fb.film_id) AS film_count,
        SUM(p.amount) AS length_band_revenue
    FROM film_band fb
    JOIN sakila.inventory i ON fb.film_id = i.film_id
    JOIN sakila.rental r    ON i.inventory_id = r.inventory_id
    JOIN sakila.payment p   ON r.rental_id = p.rental_id
    GROUP BY fb.length_band)

SELECT length_band, film_count, length_band_revenue
FROM revenue
ORDER BY length_band DESC;
```

<BarChart
  data={runtime_revenue}
  x="length_band"
  y="length_band_revenue"
  series="length_band"
  title="Total Revenue by Film Length Band"
  sort={{ x: ["Short", "Medium", "Long"] }}
  yTickCount={5}
/>


# Task 1 D: The top 10 most expensive movies to rent per day.

```sql top10_expensive_films
WITH x AS (
  SELECT
    f.film_id,
    f.title,
    f.rental_rate,
    f.rental_duration,
    ROUND(f.rental_rate / f.rental_duration, 2) AS daily_price
  FROM film f),
           
ranked AS (
  SELECT
    film_id, title, rental_rate, rental_duration, daily_price,
    DENSE_RANK() OVER (ORDER BY daily_price DESC) AS rank_num
  FROM x)
           
SELECT
  rank_num AS rank, title, daily_price, rental_rate, rental_duration
FROM ranked
WHERE rank_num <= 10
ORDER BY rank_num, title;
```
<DataTable
    data={top10_expensive_films}
    title="Top 10 Most Expensive Films"
/>

## EXTRA EDA 2: Price band distribution analysis
### A. Analyze the price band distribution and aggregate film count per price band.

```price_band_stats
SELECT
  COUNT(*)                               AS n,
  MIN(rental_rate / rental_duration)     AS min,
  AVG(rental_rate / rental_duration)     AS mean,
  MEDIAN(rental_rate / rental_duration)  AS median,
  MAX(rental_rate / rental_duration)     AS max
FROM film;
```

### B. Compute percentiles to show price distribution in bins (low, medium, high, very high)

* The daily price ranges for each price band are pre-calculated as follows:
```sql daily_price_range
SELECT * FROM (
    VALUES
        ('Low price',       '≤ 0.598'),
        ('Medium price',    '> 0.598 and ≤ 0.9967'),
        ('High price',      '> 0.9967 and ≤ 1.2475'),
        ('Very High price', '> 1.2475')
) AS t("Price Band", "Daily Price Range");
```


```sql price_band_distribution
WITH daily_price AS (
    SELECT ROUND(rental_rate / rental_duration, 4) AS daily_price
    FROM film),

thresholds AS (
    SELECT
        quantile_cont(daily_price, 0.50) AS low,
        quantile_cont(daily_price, 0.75) AS medium,
        quantile_cont(daily_price, 0.90) AS high
    FROM daily_price),

banded AS (
    SELECT daily_price,
        CASE
            WHEN daily_price <= low THEN 'Low price'
            WHEN daily_price <= medium THEN 'Medium price'
            WHEN daily_price <= high THEN 'High price'
            ELSE 'Very High price'
        END AS price_band
    FROM daily_price, thresholds)

SELECT
    price_band AS "Price Band",
    COUNT(*) AS "Number of Films"
FROM banded
GROUP BY price_band
ORDER BY COUNT(*) DESC;
```

<BarChart
  data={price_band_distribution}
  x="Price Band"
  y="Number of Films"
  series="Price Band"
  title="Number of Films by Price Band"
  sort={{ x: ["Low price", "Medium price", "High price", "Very High price"] }}
  yTickCount={6}
/>



# Task 1 E: Top 10 actors with the most movies.
```sql top10_actors
WITH actor_counts AS (
    SELECT
        a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(*) AS movie_count
    FROM sakila.actor a
    JOIN sakila.film_actor fa
        ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
),
ranked AS (
    SELECT
        first_name,
        last_name,
        movie_count,
        DENSE_RANK() OVER (ORDER BY movie_count DESC) AS rank
    FROM actor_counts)
SELECT rank, first_name, last_name, movie_count
FROM ranked
WHERE rank <= 10
ORDER BY rank ASC, first_name ASC, last_name ASC;
```

<DataTable
  data={top10_actors}
  title="Top 10 Actors by Number of Movies"
  rowsPerPage={10}
/>

## EXTRA EDA 3: Top 10 revenue-generating films and their genres.
```sql top10_revenue_films
SELECT 
  f.film_id,
  f.title,
  c.name AS genre,
  ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY f.film_id, f.title, c.name
ORDER BY revenue DESC, f.title ASC
LIMIT 10;
```

<BarChart
  data={top10_revenue_films}
  x="title"
  y="revenue"
  series="genre"
  title="Top 10 Films by Total Revenue (by Genre)"
  sort={{ x: { by: "y", order: "desc" } }}
  yMin={180}
  yTickValues={[180, 200, 220, 240]}
/>

## EXTRA EDA 4: Top-earning ranking segments
### A. How many films exist in each rating category.

```sql films_per_rating
SELECT
    rating,
    COUNT(*) AS number_of_films
FROM film
GROUP BY rating
ORDER BY number_of_films DESC;
```

### B.How much revenue per rating class is generated.
```sql revenue_per_rating
SELECT
    f.rating,
    SUM(p.amount) AS revenue
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY revenue DESC;
```

<BarChart
  data={revenue_per_rating}
  x="rating"
  y="revenue"
  series="rating"
  colorPalette="default"
  title="Total Revenue by Film Rating"
  sort={{ x: { by: "y", order: "desc" } }}
/>

# Task 2A: Top 5 customers by total spending.
```sql top5_customers
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    ROUND(SUM(p.amount), 2) AS total_spend
FROM sakila.payment p
JOIN sakila.customer c
    ON p.customer_id = c.customer_id
GROUP BY customer
ORDER BY total_spend DESC
LIMIT 6;
```

<BarChart
  data={top5_customers}
  x="customer"
  y="total_spend"
  title="Top 6 Customers by Total Spend"
  sort={{ x: { by: "y", order: "desc" } }}
  series="customer"
  colorPalette="default"
  yMin={180}
  yMax={225}
  yTickValues={[180, 195, 205, 215, 225]}
/>


# Task 2B : Top revenue-generating film categories.
```sql top_genre_revenue
SELECT
    c.name AS genre,
    ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY revenue DESC;
```

<BarChart
  data={top_genre_revenue}
  x="genre"
  y="revenue"
  series="genre"
  title="Total Revenue by Genre"
  sort={{ x: { by: "y", order: "desc" } }}
  yMin={3000}
  yMax={5400}
  yTickValues={[3000, 3300, 3600, 3900, 4200, 4500, 4800, 5100, 5400]}
/>

# Task 2C: Most number of films per category.
```sql films_per_genre
SELECT
    c.name AS genre,
    COUNT(*) AS film_count
FROM sakila.film f
JOIN sakila.film_category fc
    ON f.film_id = fc.film_id
JOIN sakila.category c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY film_count DESC, genre;
```

<BarChart
  data={films_per_genre}
  x="genre"
  y="film_count"
  series="genre"
  title="Number of Films per Genre"
  sort={{ x: { by: "y", order: "desc" } }}
  yMin={50}
  yMax={75}
  yTickValues={[50, 55, 60, 65, 70, 75]}
/>
