-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
SELECT matchid, player 
FROM goal 
WHERE teamid = 'GER'

-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
WHERE id = 1012

-- You can combine the two steps into a single query with a JOIN.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
WHERE goal.teamid = 'GER'

-- Use the same JOIN as in the previous question.
-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player FROM game
JOIN goal ON id=matchid
WHERE player LIKE 'Mario%'

-- The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON teamid=id
 WHERE gtime<=10

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname FROM game
JOIN eteam ON team1=eteam.id
WHERE coach = 'Fernando Santos'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player FROM goal
JOIN game ON matchid=id
WHERE stadium = 'NatiONal Stadium, Warsaw'

-- The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.
SELECT distinct(player)
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER')
AND teamid != 'GER'

-- Show teamname and the total number of goals scored.
SELECT teamname, count(gtime)
  FROM eteam JOIN goal ON id=teamid
GROUP BY teamname
 ORDER BY teamname

 -- Show the stadium and the number of goals scored in each stadium.
 select stadium, count(gtime) FROM game
JOIN goal ON id=matchid
GROUP BY stadium

--or every match involving 'POL', show the matchid, date and the number of goals scored
SELECT matchid,mdate, count(gtime)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid,mdate, count(gtime)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'GER' OR team2 = 'GER')
AND teamid = 'GER'
GROUP BY matchid, mdate

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
-- Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT id,mdate,
  team1,
  CASE WHEN teamid=team1 THEN 
  (SELECT count(gtime) FROM goal WHERE teamid = team1 AND matchid = id) ELSE 0
  END scORe1,
  team2,
  CASE when teamid=team2 then 
  (SELECT count(gtime) FROM goal WHERE teamid = team2 AND matchid = id) ELSE 0
  end scORe2
  FROM game x JOIN goal ON matchid = id
GROUP BY id, mdate, team1, teamid, team2
ORDER BY mdate

