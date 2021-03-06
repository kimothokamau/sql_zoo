-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

-- Give year of 'Citizen Kane'.
SELECT yr FROM movie
WHERE title = 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr

-- What id number does the actor 'Glenn Close' have?
SELECT id FROM actor
WHERE name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
SELECT id FROM movie
WHERE title = 'Casablanca'

-- Obtain the cast list for 'Casablanca'.
SELECT actor.name
FROM actor JOIN casting ON actor.id = casting.actorid
WHERE movieid = 11768;

-- Obtain the cast list for the film 'Alien'
SELECT name FROM
(SELECT actorid FROM (SELECT id FROM movie WHERE title = 'Alien') as movie
JOIN casting
ON (movieid=id)) as a
JOIN actor
ON (actorid = id)

--List the films in which 'Harrison Ford' has appeared
SELECT title FROM 
(SELECT title, actorid FROM movie JOIN casting ON id = movieid) as a
JOIN actor
ON actorid = id
WHERE name = 'Harrison Ford'

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM movie a
JOIN casting b ON a.id=b.movieid
JOIN actor c ON b.actorid=c.id
WHERE c.name = 'Harrison Ford'
AND b.ord !=1

-- List the films together with the leading star for all 1962 films.
SELECT title, name FROM 
(SELECT title, actorid FROM movie JOIN casting ON id = movieid 
WHERE ord = 1 AND yr = 1962) as a
JOIN actor
ON actorid = id

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title) AS movies_made
FROM movie JOIN casting 
ON movie.id = casting.movieid
JOIN actor   
ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name FROM
movie JOIN casting ON (movieid = movie.id AND ord = 1)
JOIN actor ON (actorid = actor.id)
WHERE movie.id IN (
SELECT movieid FROM casting WHERE actorid IN (
SELECT id FROM actor WHERE name = 'Julie Andrews'))