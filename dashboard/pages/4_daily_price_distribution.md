---
title: 4. Top 10 most expensive films and the price distributions
---

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

**Business insight**
- Most films are priced in the low and medium bands, suggesting there is room to increase prices slightly on selected titles without hurting demand.

- A small group of high-priced films drives premium value and should be clearly positioned and promoted as premium content to increase revenue.