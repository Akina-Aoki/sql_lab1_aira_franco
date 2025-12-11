---
title: Sakila Database Analysis
---

<Details title = 'Exploratory Data Analysis of the Sakila Database'>
This dashboard presents an exploratory data analysis of the Sakila database, which is a sample database provided by MySQL that represents a DVD rental store. 
</Details>

## Task 1 A: Which movies are longer than 180 minutes?

```sql film_180
SELECT 
    title,
    length
FROM
    film
WHERE
    length > 180
ORDER BY
    length DESC;
```


## Task 1 B: Which movies have the word "love" in the title?

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
```
   
<BarChart
    data = {film_love}
    x = "title"
    y = "length"
    color = "success"
    title = "Distribution of movies with 'Love' in the Title"
    swapXY = true 
/>


## Task 1 C: Calculate descriptive statistics. The shortest, average, median and longest movie length on the length column.

```sql film_stats
SELECT
    MIN(length) AS shortest,
    AVG(length) AS average,
    MEDIAN(length) AS median,
    MAX(length) AS longest
FROM film;
```

## Task 1 D:  The top 10 most expensive movies to rent per day.

```sql film_expensive
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
    data={film_expensive}
    title="Top 10 Most Expensive Films"
/>

## EXTRA EDA: films price distribution and percentiles
- Show summary stats (min, mean, median, max).

```sql daily_stats
SELECT
  COUNT(*)                               AS n,
  MIN(rental_rate / rental_duration)     AS min,
  AVG(rental_rate / rental_duration)     AS mean,
  MEDIAN(rental_rate / rental_duration)  AS median,
  MAX(rental_rate / rental_duration)     AS max
FROM film;
```

- Compute percentiles to group films into four simple bands (Low, Medium, High, Very High)

```sql film_price
WITH base AS (
    SELECT 
        ROUND(rental_rate / rental_duration, 4) AS daily_price
    FROM film
),
quantiles AS (
    SELECT
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY daily_price) AS p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY daily_price) AS p75,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY daily_price) AS p90
    FROM base
),
binned AS (
    SELECT
        b.daily_price,
        CASE 
            WHEN b.daily_price <= q.p50 THEN 'Low price'
            WHEN b.daily_price <= q.p75 THEN 'Medium price'
            WHEN b.daily_price <= q.p90 THEN 'High price'
            ELSE 'Very High price'
        END AS price_band
    FROM base b
    CROSS JOIN quantiles q
)
SELECT
    price_band,
    COUNT(*) AS count
FROM binned
GROUP BY price_band
ORDER BY count DESC;
```

## Task 1 E: Which actors have played in most movies?