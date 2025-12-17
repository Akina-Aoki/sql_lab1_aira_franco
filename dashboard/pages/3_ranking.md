---
title: 3. Revenue and Ranking Segments Relationship
---
Is it profitable to promote films by ratings?
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

**Business insight improvements**
- Focus marketing and promotions on ratings that generate the most revenue
- Adjust inventory to stock more films in high-revenue rating categories