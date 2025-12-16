---
title: II. Other Sakila Database Analysis
---

<Details title = 'Details of the project'>
Other insights not covered in the main Sakila analysis.
</Details>


# Which movies are longer than 180 minutes?

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

# Which movies have the word "love" in the title?

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

# Top 5 customers by total spending.
```sql top5_customers
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    ROUND(SUM(p.amount), 2) AS total_spend
FROM sakila.payment p
JOIN sakila.customer c
    ON p.customer_id = c.customer_id
GROUP BY customer
ORDER BY total_spend DESC
LIMIT 5;
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


# Top 10 actors with the most movies.
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