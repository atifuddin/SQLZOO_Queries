/*
This is my answers to the SQL Zoo Join Quiz
@ https://sqlzoo.net/wiki/More_JOIN_operations#1962_movies
 Context: This tutorial introduces the notion of a join. 
 The database consists of three tables movie , actor and casting .

*/



--Q1  List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

--Q2 Give year of 'Citizen Kane'.
 Select yr
 from movie 
 where title like '%Citizen Kane%'

--Q3 List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
Select id, title, yr from movie
where title like '%Star Trek%'
order by yr

--Q4 What id number does the actor 'Glenn Close' have?
select id 
from actor
where name like '%Glenn Close%'

--Q5 What is the id of the film 'Casablanca'
select id 
from movie 
where title like '%Casablanca%'

--Q6 Obtain the cast list for 'Casablanca'.
select t.name from
((select * from actor left join casting on
actor.id = casting.actorid) as t) left join
movie on movie.id = t.movieid where title like '%Casablanca%'

--Q7 Obtain the cast list for the film 'Alien'
select t1.name from
((select * from casting left join actor on
actor.id = casting.actorid) as t1) left join
movie on movie.id = t1.movieid where title = 'Alien'

--Q8 List the films in which 'Harrison Ford' has appeared
select t2.title from
((select * from movie left join casting on
movie.id = casting.movieid) as t2) left join actor
on actor.id = t2.actorid where name = 'Harrison Ford'

--Q9 List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
select t3.title from
((select * from movie left join casting on
movie.id = casting.movieid ) as t3) left join actor
on actor.id = t3.actorid where ord <> 1 and name = 'Harrison Ford'

--Q10 List the films together with the leading star for all 1962 films.
select t3.title, name from
((select * from movie left join casting on
movie.id = casting.movieid ) as t3) left join actor on actor.id = t3.actorid 
where ord = 1 and yr = 1962

--Q11 Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
select yr, count(title) as 'number of movies' from
((select * from movie left join casting on
movie.id = casting.movieid) as t3) left join actor on actor.id = t3.actorid 
where name = 'Rock Hudson'
GROUP BY yr 
HAVING count(title)>2

--Q12 List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name
  FROM movie, casting, actor
  WHERE movieid=movie.id
    AND actorid=actor.id
    AND ord=1
    AND movieid IN
    (SELECT movieid FROM casting, actor
     WHERE actorid=actor.id
     AND name='Julie Andrews')

--Q13 Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles
select  actor.name from actor left join
casting on (actor.id = casting.actorid)
where actorid IN
(Select actorid from casting
where ord = 1
group by actorid
having count(*) >= 15)
group by name
order by name ASC

(Or)

select name from actor left join casting
on actor.id = casting.actorid where
ord = 1
group by name
having count(*) >= 15

--Q14 List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
select title, count(actorid) from movie left join casting 
on movie.id = casting.movieid where
yr = 1978 
group by title
Order by 2 DESC

--Q15 List all the people who have worked with 'Art Garfunkel'.
select distinct name from actor join casting 
on actor.id = casting.actorid where name <> 'Art Garfunkel' and 
movieid IN (select movieid from actor join casting 
on actor.id = casting.actorid where name = 'Art Garfunkel')

