---
title: Welcome to Sakila Database Analysis
---

<Details title='How to edit this page'>
    This page can be found in your project at `/pages/sakila.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>

# Exploratory Data Analysis of the Sakila Database
This dashboard presents an exploratory data analysis of the Sakila database, which is a sample database provided by MySQL that represents a DVD rental store. The analysis includes various visualizations and insights derived from the data contained within the Sakila database.

## Task 1 A: Which movies are longer than 180 minutes?
## Films table test

```sql film
SELECT *
FROM sakila.film;
```


## Task 1 B: Which movies have the word "love" in the title?

```sql film
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



