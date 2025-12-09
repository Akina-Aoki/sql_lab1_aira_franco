# Exploratory Data Analysis of the Sakila Database
This dashboard presents an exploratory data analysis of the Sakila database, which is a sample database provided by MySQL that represents a DVD rental store. The analysis includes various visualizations and insights derived from the data contained within the Sakila database.

## Task 1 A: Which movies are longer than 180 minutes?

```
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
