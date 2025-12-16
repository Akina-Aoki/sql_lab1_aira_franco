---
title: 5. Runtime and Revenue Relationship
---

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