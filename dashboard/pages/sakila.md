---
title: Sakila Database Analysis
---

<Details title = 'Exploratory Data Analysis of the Sakila Database'>
This dashboard presents an exploratory data analysis of the Sakila database, which is a sample database provided by MySQL that represents a DVD rental store. 

The analysis includes various visualizations and insights derived from the data contained within the Sakila database.
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
<Histogram
    data={film_180}
    x = "title"
    y = "length"
    title = "Movies Longer than 180 Minutes"
/>


## Task 1 B: Which movies have the word "love" in the title?

``` sql film_love
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

## EXTRA EDA: films price distribution and percentiles
This section summarizes daily rental prices across all films.
- We can also show all the films that has a daily_price of 1.66
- Show summary stats (min, mean, median, max).
- Compute percentiles to show typical (median) and high-end prices 

### All the films that has a daily_price of 1.66
```sql films_price_166
SELECT
  title,
  ROUND(rental_rate / rental_duration, 2) AS daily_price
FROM film
WHERE daily_price = 1.66
ORDER BY title;
```