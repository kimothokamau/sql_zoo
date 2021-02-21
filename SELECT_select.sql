-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')


-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
WHERE continent = 'EUROPE' AND (gdp/population) >
  (SELECT (gdp/population) FROM world
    WHERE name = 'United Kingdom')

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

SELECT name, continent
FROM world
WHERE continent IN ('South America', 'Oceania')
ORDER by name

-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada') AND
population < (SELECT population FROM world WHERE name = 'Poland')

-- Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.

-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(CONVERT(DOUBLE PRECISION, ROUND((population/(SELECT population FROM world WHERE name = 'Germany')) * 100, 0)), '%') 
AS percentage FROM world WHERE continent = 'Europe'

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
FROM world
WHERE GDP > (SELECT MAX(gdp) from WORLD where continent = 'Europe')

-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area 
FROM world 
WHERE 
area = (SELECT MAX(area) FROM world WHERE continent = 'Europe') OR 
area = (SELECT MAX(area) FROM world WHERE continent = 'Africa') OR 
area = (SELECT MAX(area) FROM world WHERE continent = 'North America') OR 
area = (SELECT MAX(area) FROM world WHERE continent = 'South America') OR 
area = (SELECT MAX(area) FROM world WHERE continent = 'Oceania') OR
area = (SELECT MAX(area) FROM world WHERE continent = 'Asia') OR
area = (SELECT MAX(area) FROM world WHERE continent = 'Eurasia') OR
area = (SELECT MAX(area) FROM world WHERE continent = 'Caribbean') 

-- List each continent and the name of the country that comes first alphabetically.
SELECT continent, min(name) AS name
FROM world
GROUP BY continent
ORDER BY continent


-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population
FROM world a
WHERE 25000000 >= ALL(SELECT population FROM world b WHERE b.continent LIKE a.continent)

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent 
FROM world w
  WHERE population >= ALL(SELECT population*3
  FROM world y
  WHERE w.continent = y.continent
  and y.name != w.name)