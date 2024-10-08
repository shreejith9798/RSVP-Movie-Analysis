USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(movie_id) as dir_total_rows
FROM director_mapping;
-- 3867 row count

SELECT count(movie_id) as genre_total_rows
FROM genre;
-- 14662

SELECT count(id) as movie_total_rows
FROM movie;
-- 7997

SELECT count(id) as names_total_rows
FROM names;
-- 25735

SELECT count(movie_id) as ratings_total_rows
FROM ratings;
-- 7997

SELECT count(movie_id) as role_mapping_total_rows
FROM role_mapping;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_nulls,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_nulls,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_nulls,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_nulls,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_nulls,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_nulls,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_nulls,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_nulls
FROM   movie; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for the first part of the question
SELECT year AS Year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

-- Code for the second part of the question
SELECT Month(date_published) AS month_num,
       Count(Month(date_published)) AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(*) AS Number_of_movies
FROM   movie
WHERE  year = 2019
       AND ( country LIKE '%USA%'
              OR country LIKE '%INDIA%' ); 


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(mov.id) AS Number_of_movies
FROM   movie mov
       INNER JOIN genre gen
               ON mov.id = gen.movie_id
GROUP  BY genre
ORDER  BY Count(id) DESC
LIMIT  1; 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH mov_single_genre
     AS (SELECT movie_id,
                Count(genre)
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT Count(movie_id) AS Number_of_movies_with_1_genre
FROM   mov_single_genre; 


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       Round(Avg(mov.duration), 2) AS avg_duration
FROM   movie mov
       INNER JOIN genre gen
               ON mov.id = gen.movie_id
GROUP  BY genre
ORDER  BY Avg(mov.duration) DESC; 



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH thriller_genre_rank
     AS (SELECT genre,
                Count(movie_id) movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   thriller_genre_rank
WHERE  genre = "thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


SELECT title,
       avg_rating,
       Dense_rank()
         OVER(
           ORDER BY avg_rating DESC) AS movie_rank
FROM   movie mov
       INNER JOIN ratings rat
               ON mov.id = rat.movie_id limit 10; 




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating; 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
       Count(id) AS movie_count,
       Dense_rank()
         OVER(
           ORDER BY Count(id) DESC) AS prod_company_rank
FROM   movie mov
       INNER JOIN ratings rat
               ON mov.id = rat.movie_id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company; 






-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Count(*) AS movie_count
FROM   genre gen
       INNER JOIN movie mov
               ON gen.movie_id = mov.id
       INNER JOIN ratings rat
               ON rat.movie_id = mov.id
WHERE  ( year = 2017 )
       AND ( Month(date_published) = 03 )
       AND ( country LIKE '%USA%' )
       AND ( ( total_votes ) > 1000 )
GROUP  BY genre
ORDER  BY Count(mov.id) DESC; 



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre gen
       INNER JOIN movie mov
               ON gen.movie_id = mov.id
       INNER JOIN ratings rat
               ON rat.movie_id = mov.id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
ORDER  BY avg_rating DESC; 





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(mov.id) AS number_of_movies
FROM   movie mov
       INNER JOIN ratings rat
               ON mov.id = rat.movie_id
WHERE  ( date_published BETWEEN '2018-04-01' AND '2019-04-01' )
       AND ( median_rating = 8 ); 






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes_summary AS
(
       SELECT table1.german_votes,
              table2.italian_votes
       FROM   (
                         SELECT     Sum(total_votes) AS german_votes
                         FROM       movie            AS m
                         INNER JOIN ratings          AS r
                         ON         m.id = r.movie_id
                         WHERE      languages LIKE '%German%') Table1
       JOIN
              (
                         SELECT     Sum(total_votes) AS italian_votes
                         FROM       movie            AS m
                         INNER JOIN ratings          AS r
                         ON         m.id = r.movie_id
                         WHERE      languages LIKE '%Italian%') Table2)
SELECT IF(german_votes>italian_votes, "YES", "NO") as is_max_votes_to_german_movies FROM votes_summary;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with genre_tab AS
(
           SELECT genre
           FROM   genre
           INNER JOIN ratings
           using  (movie_id)
           WHERE  avg_rating>8
           GROUP BY genre
           ORDER BY Count(movie_id) DESC LIMIT 3 )
SELECT     NAME as director_name,
           Count(dir.movie_id) AS movie_count
FROM       names nam
INNER JOIN director_mapping dir
ON         nam.id = dir.name_id
INNER JOIN genre
using      (movie_id)
INNER JOIN ratings rat
using      (movie_id)
INNER JOIN genre_tab 
using (genre)
WHERE avg_rating>8
GROUP BY   NAME
ORDER BY   Count(dir.movie_id) DESC LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT name as actor_name, count(movie_id) as movie_count
From role_mapping rol
INNER JOIN names nam ON rol.name_id = nam.id
INNER JOIN ratings
USING (movie_id)
WHERE category = "actor" AND median_rating >= 8
GROUP BY name
ORDER BY movie_count DESC LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
                Sum(total_votes) AS vote_count,
                Row_number()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie mov
                INNER JOIN ratings rat
                        ON mov.id = rat.movie_id
         GROUP  BY production_company order by vote_count DESC LIMIT 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_actors AS
(
           SELECT     NAME as actor_name,
                      Sum(total_votes) AS total_votes,
                      Count(NAME) AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actor_avg_rating
           FROM       names nam
           INNER JOIN role_mapping rol
           ON         nam.id = rol.name_id
           INNER JOIN movie mov
           ON         rol.movie_id = mov.id
           INNER JOIN ratings rat
           ON         mov.id = rat.movie_id
           WHERE      (
                        country LIKE '%India%')
           AND        category = 'actor'
           GROUP BY   NAME
           HAVING     (
						Count(NAME)>=5) )
SELECT   *,
         Dense_rank()OVER(ORDER BY actor_avg_rating DESC,total_votes DESC)AS actor_rank
FROM     top_actors ;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress
     AS (SELECT NAME AS actress_name,
                Sum(total_votes)  AS
                   total_votes, 
                Count(NAME) AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actress_avg_rating
         FROM   names nam
                INNER JOIN role_mapping rol
                        ON nam.id = rol.name_id
                INNER JOIN movie mov
                        ON rol.movie_id = mov.id
                INNER JOIN ratings rat
                        ON mov.id = rat.movie_id
         WHERE  ( country LIKE '%India%' )
                AND ( category = 'actress' )
                AND ( languages LIKE '%Hindi%' )
         GROUP  BY NAME
         HAVING ( Count(NAME) >= 3 ))
SELECT *,
       Dense_rank()
         OVER(
           ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM   top_actress limit 5 ; 



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT title As movie_name, avg_rating, 
CASE 
	WHEN avg_rating > 8 THEN "Superhit movies" 
	WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies" 
	WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies" 
	ELSE "Flop Movies" 
	END AS avg_rating_category 
FROM movie AS mov 
INNER JOIN genre AS gen ON mov.id = gen.movie_id 
INNER JOIN ratings rat ON rat.movie_id = mov.id 
WHERE genre="thriller";


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
/*
For running total we have assumed the window to be the rows till the current value and 
For moving average calculation we have assumed the window to be a set of 3 rows
i.e. 1 row before and 1 row after including current row
*/
SELECT genre,
       Round(Avg(duration), 2) AS avg_duration,
       Round(SUM(Avg(duration))
               over (
                 ORDER BY Avg(duration) DESC ROWS unbounded preceding), 2) AS running_total_duration,
       Round(Avg(Avg(duration))
               over(
                 ORDER BY Avg(duration) DESC ROWS BETWEEN 1 preceding AND 1
               following),
       2)   AS moving_avg_duration
FROM   movie mov
       inner join genre gen
               ON mov.id = gen.movie_id
GROUP  BY genre; 







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
/*We have assumed the value of 1 INR = 0.012 $ and used the same in conversion of few values of worldwide_gross_income 
which were in INR into $
*/
WITH top_genre
     AS (SELECT genre,
                Count(mov.id),
                Row_number()
                  over(
                    ORDER BY Count(mov.id) DESC) AS ranking
         FROM   genre gen
                inner join movie mov
                        ON mov.id = gen.movie_id
         GROUP  BY genre),
     top
     AS (SELECT id,
                gen.genre,
                year,
                title AS movie_name,
                CASE
                  WHEN worlwide_gross_income LIKE 'INR%' THEN Cast(
                  Substring(worlwide_gross_income, 5) AS UNSIGNED) * 0.012
                  ELSE Cast(Substring(worlwide_gross_income, 2) AS UNSIGNED)
                END   AS world_gross_income
         FROM   movie mov
                inner join genre gen
                        ON mov.id = gen.movie_id
         WHERE  genre IN (SELECT genre
                          FROM   top_genre
                          WHERE  ranking < 4)),
     final_list
     AS (SELECT top.genre,
                year,
                movie_name,
                Concat('$', world_gross_income) AS worldwide_gross_income,
                Row_number()
                  over(
                    PARTITION BY year
                    ORDER BY world_gross_income DESC) AS movie_rank
         FROM   top)
SELECT *
FROM   final_list
WHERE  movie_rank <= 5; 





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Count(mov.id)  AS movie_count,
           Row_number() OVER(ORDER BY Count(mov.id) DESC) AS prod_comp_rank
FROM       movie mov
INNER JOIN ratings rat
ON         mov.id = rat.movie_id
WHERE      median_rating>=8
AND        position(',' IN languages)>0
AND        production_company IS NOT NULL
GROUP BY   production_company LIMIT 2;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     NAME as actress_name,
		   Sum(total_votes) AS total_votes,
           Count(mov.id) AS movie_count,
           Round(SUM(avg_rating*total_votes) / SUM(total_votes) ,2)  AS actress_avg_rating,
           Row_number() OVER(ORDER BY Count(mov.id) DESC) AS actress_rank
FROM       names nam
INNER JOIN role_mapping rol
ON         nam.id = rol.name_id
INNER JOIN movie mov
ON         mov.id = rol.movie_id
INNER JOIN ratings rat
ON         mov.id = rat.movie_id
INNER JOIN genre gen
ON         mov.id = gen.movie_id
WHERE      avg_rating>8
AND        genre = 'Drama'
AND        rol.category = 'actress'
GROUP BY   NAME limit 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:




WITH t_date_summary AS
(
           SELECT     dir.name_id,
                      NAME,
                      dir.movie_id,
                      duration,
                      rat.avg_rating,
                      total_votes,
                      mov.date_published,
                      Lead(date_published,1) OVER(partition BY dir.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping  AS dir
           INNER JOIN names   AS nam
           ON         nam.id = dir.name_id
           INNER JOIN movie AS mov
           ON         mov.id = dir.movie_id
           INNER JOIN ratings AS rat
           ON         rat.movie_id = mov.id ), 
	
    top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   t_date_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference)) AS avg_inter_movie_days,
         Round(SUM(avg_rating*total_votes) / SUM(total_votes) ,2) AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;


