---
title: 2. Revenue and Genre Relationship
---

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

**Improvements from the business insight**
- Increase the number of copies for top revenue films
- Use them in promotions and seasonal campaigns
- Feature them more prominently to drive rentals
- Use these films as anchors when expanding similar titles or genres
