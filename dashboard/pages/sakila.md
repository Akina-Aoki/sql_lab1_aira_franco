---
title: 1. Top revenue-generating film categories.
---

<Details title = 'Details of the project'>
This analysis supports management decisions for a DVD rental business preparing for seasonal incentives and future expansion.

The goal is to understand what drives revenue, how pricing and content length affect performance, and where inventory and demand are misaligned.
</Details>


# Top revenue-generating film categories.
Which film categories bring in the most money?

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

## Inventory number of films per category.
Where is the company currently investing its inventory?

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

**Improvements from the business insight**
- Increase acquisition and availability in high-revenue, under-represented categories
- Slow or cap expansion in low-revenue, over-represented categories
- Use revenue-per-film (not film count) as a guiding KPI for future expansion


# Top 10 revenue-generating films and their genres.
Which individual films actually drive revenue, and how can we use that to grow sales?

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
**Business insight**
- Increase the number of copies for top revenue films
- Use them in promotions and seasonal campaigns
- Feature them more prominently to drive rentals
- Use these films as anchors when expanding similar titles or genres


# Top-earning ranking segments
How many films exist in each rating category.

```sql films_per_rating
SELECT
    rating,
    COUNT(*) AS number_of_films
FROM film
GROUP BY rating
ORDER BY number_of_films DESC;
```

<DataTable
  data={films_per_rating}
  title="Number of Films by Rating"
  rowsPerPage={10}
/>

# How much revenue per rating class is generated.
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
**Business insight**
- Focus marketing and promotions on ratings that generate the most revenue
- Adjust inventory to stock more films in high-revenue rating categories

# Top 10 most expensive movies to rent per day.
How is our rental pricing structured, and where do we have room to improve revenue without breaking customer demand?
Look at: 
1. The most expensive films per day (premium titles)
2. The overall price distribution (how the full catalog is priced)

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

# Daily_price band distribution analysis:
## Analyze the price band distribution and aggregate film count per price band.

```price_band_stats
SELECT
  COUNT(*)                               AS n,
  MIN(rental_rate / rental_duration)     AS min,
  AVG(rental_rate / rental_duration)     AS mean,
  MEDIAN(rental_rate / rental_duration)  AS median,
  MAX(rental_rate / rental_duration)     AS max
FROM film;
```

## Compute percentiles to show price distribution in bins (low, medium, high, very high)

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


# Statistics on movie lengths in the inventory
Check the stats of the shortest, average, median and longest movies in the inventory.

```sql film_stats
SELECT
    MIN(length) AS shortest,
    AVG(length) AS average,
    MEDIAN(length) AS median,
    MAX(length) AS longest
FROM film;
```

# How does film runtime relate to overall revenue?

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

**Business insight**
Revenue is not evenly distributed across runtime categories.
Revenue is highest for medium-length films compared to short and long films.