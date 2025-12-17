---
title: 1. Revenue and Film Inventory Relationship
---

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

**Business insight**
- Demand higher than supply
- Strong genres perform better
- Current catalog not balanced
- Add more movies in top genres
- Increase revenue without more inventory
- Avoid low profit genres


