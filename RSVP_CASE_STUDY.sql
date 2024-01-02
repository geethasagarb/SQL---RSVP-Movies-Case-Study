USE imdb;

/*  To begin with, it is beneficial to know the shape of the tables and whether any column has null values. */



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?


SELECT Count(*) AS NO_OF_ROWS_MOVIE
FROM   movie;
-- Movie table has 7997 rows.


SELECT Count(*) AS NO_OF_ROWS_DIRECTOR_MAPPING
FROM   director_mapping;
-- Director_mapping has 3867 rows.


SELECT Count(*) AS NO_OF_ROWS_GENRE
FROM   genre;
-- Genre has 14662 rows


SELECT Count(*) AS NO_OF_ROWS_NAMES
FROM   names;
-- Names table has 25735 rows.


SELECT Count(*) AS NO_OF_ROWS_RATINGS
FROM   ratings;
-- Ratings table has 7997 rows.


SELECT Count(*) AS NO_OF_ROWS_ROLE_MAPPING
FROM   role_mapping;
-- Role_mapping has 15615 rows.









-- Q2. Which columns in the movie table have null values?


SELECT Sum(CASE
             WHEN m.id IS NULL THEN 1
             ELSE 0
           END) AS id_null_count,
       Sum(CASE
             WHEN m.title IS NULL THEN 1
             ELSE 0
           END) AS title_null_count,
       Sum(CASE
             WHEN m.year IS NULL THEN 1
             ELSE 0
           END) AS year_null_count,
       Sum(CASE
             WHEN m.date_published IS NULL THEN 1
             ELSE 0
           END) AS date_null_count,
       Sum(CASE
             WHEN m.duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null_count,
       Sum(CASE
             WHEN m.country IS NULL THEN 1
             ELSE 0
           END) AS country_null_count,
       Sum(CASE
             WHEN m.worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS gross_income_null_count,
       Sum(CASE
             WHEN m.languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null_count,
       Sum(CASE
             WHEN m.production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_null_count
FROM   movie AS m;  

/*  Output :

	id_null_count	title_null_count	year_null_count	  date_null_count	duration_null_count  	country_null_count  	gross_income_null_count	  languages_null_count	  production_company_null_count
		0					0					0				0					0					20						3724				194						528                   */



/* As you can see country, worldwide_gross_income, languages and production_company od movie table has null values.  */


 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? 

-- 1st part of the question

SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

/* Output for the first part:

+-------------------+-------------------+
| Year				|	number_of_movies|
+-------------------+----------------
	2017					3052
	2018					2944
	2019					2001		*/

-- 2nd part of the question

SELECT Month(date_published) AS month,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published);

/* Output for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
		1			804
		2			640
		3			824
		4			680
		5			625
		6			580
		7			493
		8			678
		9			809
		10			801
		11			625
		12			438 		*/

-- The highest number of movies is produced in the month of March.




  
-- Q4. How many movies were produced in the USA or India in the year 2019??


SELECT Count(id) AS Movies_IN_USA_INDIA
FROM   movie
WHERE  year = 2019
       AND ( country LIKE '%USA%'
              OR country LIKE '%india%' ); 

-- 1059 movies were produced in the USA or India in the year 2019. 






-- Q5. Find the unique list of the genres present in the data set?


SELECT DISTINCT( genre ) AS GENRES
FROM   genre; 

-- Answer :
-- Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery and Others is the unique list of the genres present in the data set.






-- Q6.Which genre had the highest number of movies produced overall?


SELECT genre,
       COUNT(movie_id) AS Movie_Count
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY COUNT(movie_id) DESC
LIMIT  1; 

-- Drama as a genre had the highest number of movies produced overall.



-- To find out which genre has the highest number of movies produced in the year 2019

SELECT COUNT(m.id), genre
FROM movie m
		INNER JOIN
			genre g 
				ON m.id=g.movie_id
WHERE year=2019
GROUP BY genre
LIMIT 1;

/*	A total of 1078 movies were produced in the year 2019 in ‘Drama’ genre,
	which has the highest number of movies produced in the last year i.e 2019. */






-- Q7. How many movies belong to only one genre?


WITH movie_having_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(movie_id) AS movies_with_one_genre
FROM   movie_having_one_genre; 

-- 3289 movies belong to only one genre.






-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



WITH movie_genre
     AS (SELECT g.genre,
                m.duration
         FROM   genre g
                INNER JOIN movie m
                        ON g.movie_id = m.id)
SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie_genre
GROUP  BY genre
ORDER  BY Round(Avg(duration), 2) DESC; 


/* Output :

+-------------------+-------------------+
| genre				|	avg_duration	|
+-------------------+--------------------
	Action				112.88
	Romance				109.53
	Crime				107.05
	Drama				106.77
	Fantasy				105.14
	Comedy				102.62
	Adventure			101.87
	Mystery				101.80
	Thriller			101.58
	Family				100.97
	Others				100.16
	Sci-Fi				97.94
	Horror				92.72 		     */







-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)




WITH genre_rank
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = 'thriller'; 

/* Output :
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3    	  |
+---------------+-------------------+---------------------+*/








-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?


SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 


/* Output :
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/




    


-- Q11. Which are the top 10 movies based on average rating?

-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rating AS
(
           SELECT     m.title,
                      r.avg_rating
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id=r.movie_id )
SELECT   *,
         DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM     movie_rating limit 10;



/* Output :
+--------------------------------+-------------------+---------------------+
| title			                 |		avg_rating	|		movie_rank    |
+--------------------------------+-------------------+---------------------+
Kirket	                                  10.0	              1
Love in Kilnerry	                      10.0	              1
Gini Helida Kathe	                      9.8	              2
Runam	                                  9.7	              3
Fan	                                      9.6	              4
Android Kunjappan Version 5.25			  9.6				  4
Yeh Suhaagraat Impossible				  9.5			   	  5
Safe									  9.5				  5
The Brighton Miracle					  9.5				  5
Shibu									  9.4				  6 */







-- Q12. Summarise the ratings table based on the movie counts by median ratings.

-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY Count(movie_id) DESC; 


/* Output :

+---------------+-------------------+
| median_rating	|	movie_count		|
+---------------+----------------
7					2257
6					1975
8					1030
5					985
4					479
9					429
10					346
3					283
2					119
1					94 				*/

-- Movies with a median rating of 7 is highest in number.







-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rating
     AS (SELECT m.production_company,
                m.id
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND m.production_company IS NOT NULL)
SELECT production_company,
       Count(id)                    AS movie_count,
       DENSE_RANK()
         OVER(
           ORDER BY Count(id) DESC) AS production_company_rank
FROM   movie_rating
GROUP  BY production_company
LIMIT 2; 



/* Output :
+------------------------+-------------------+---------------------+
|production_company      |  movie_count	       |	prod_company_rank|
+------------------------+-------------------+---------------------+
Dream Warrior Pictures			3						1
National Theatre Live			3						1               */



-- Answer can be Dream Warrior Pictures or National Theatre Live or both






-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?


WITH movie_ratings_genre
     AS (SELECT m.year,
                m.date_published,
                r.total_votes,
                g.genre,
                m.id,
                m.country
         FROM   genre g
                INNER JOIN movie m
                        ON g.movie_id = m.id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  Month(date_published) = 3
                AND year = 2017
                AND country LIKE '%USA%'
                AND total_votes > 1000)
SELECT genre,
       Count(id) AS movie_count
FROM   movie_ratings_genre
GROUP  BY genre
ORDER  BY Count(id) DESC; 


/* Output :

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
	Drama				24
	Comedy				9
	Action				8
	Thriller			8
	Sci-Fi				7
	Crime				6
	Horror				6
	Mystery				4
	Romance				4
	Fantasy				3
	Adventure			3
	Family				1                         */








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?


WITH movie_ratings_genre
     AS (SELECT m.title,
                r.avg_rating,
                g.genre
         FROM   genre g
                INNER JOIN movie m
                        ON g.movie_id = m.id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  title LIKE 'The%'
                AND avg_rating > 8)
SELECT title,
       avg_rating,
       genre
FROM   movie_ratings_genre
ORDER  BY avg_rating DESC; 


/* Output :
+---------------------+-------------------+---------------------+
| title			      |		avg_rating	|		genre	      |
+---------------------+-------------------+---------------------+
The Brighton Miracle		9.5					Drama
The Colour of Darkness		9.1					Drama
The Blue Elephant 2			8.8					Drama
The Blue Elephant 2			8.8					Horror
The Blue Elephant 2			8.8					Mystery
The Irishman				8.7					Crime
The Irishman				8.7					Drama
The Mystery of Godliness	8.5					Drama
The Gambinos				8.4					Crime
The Gambinos				8.4					Drama
Theeran Adhigaaram Ondru	8.3					Action
Theeran Adhigaaram Ondru	8.3					Crime
Theeran Adhigaaram Ondru	8.3					Thriller
The King and I				8.2					Drama
The King and I				8.2					Romance*/







-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(m.id) AS no_of_movies_released
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  ( r.median_rating = 8 )
       AND ( m.date_published BETWEEN '2018-04-01' AND '2019-04-01' ); 

-- 361 movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8.







-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.



-- Total votes of italian movies
SELECT Sum(r.total_votes) AS count_italian_movies
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%italian%';
-- italian -2559540


-- Total votes of german movies
SELECT Sum(r.total_votes) AS count_german_movies
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.languages LIKE '%german%';
-- german - 4421525


-- german - 4421525
-- italian -2559540

-- Answer is Yes, German movies get more votes than Italian movies.






-- Segment 3:



-- Q18. Which columns in the names table have null values??


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
           END) AS DOB_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS know_for_movies_nulls
FROM   names; 


/* Output :
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
	0					17335				13431					15226           */


-- There are no Null value in the column 'name'.





-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)


WITH top_3_genres_movie_director AS
(
           SELECT     genre,
                      Count(m.id)                                  AS movie_count ,
                      Dense_rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie m
           INNER JOIN genre g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre g
using      (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres_movie_director
using      (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC
LIMIT 3;


/* Output :

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
  James Mangold			4
  Anthony Russo			3
  Soubin Shahir			3			*/


/* James Mangold can be hired as the director for RSVP's next project. We remeber his movies, 'Logan' and 'The Wolverine'. */





-- Q20. Who are the top two actors whose movies have a median rating >= 8?



SELECT n.name,
       Count(rm.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN ratings r
               ON r.movie_id = rm.movie_id
WHERE  r.median_rating >= 8
GROUP  BY n.name
ORDER  BY Count(rm.movie_id) DESC
LIMIT  2; 


/* Output :

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
	Mammootty			8
	Mohanlal			5			*/






-- Q21. Which are the top three production houses based on the number of votes received by their movies?



SELECT     m.production_company,
           Sum(r.total_votes)                                  AS vote_count,
           Dense_rank() OVER(ORDER BY Sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
GROUP BY   m.production_company
ORDER BY   Sum(r.total_votes) DESC limit 3;


/* Output :
+---------------------+---------------------+---------------------+
|production_company   |vote_count			|		prod_comp_rank|
+---------------------+---------------------+---------------------+
	Marvel Studios		2656967					1
Twentieth Century Fox	2411163					2
	Warner Bros.		2396057					3				*/








-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)




WITH rank_actors
     AS (SELECT NAME                                                       AS
                actor_name
                ,
                Sum(total_votes)
                AS
                   total_votes,
                Count(a.movie_id)                                          AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   role_mapping a
                INNER JOIN names b
                        ON a.name_id = b.id
                INNER JOIN ratings c
                        ON a.movie_id = c.movie_id
                INNER JOIN movie d
                        ON a.movie_id = d.id
         WHERE  category = 'actor'
                AND country LIKE '%India%'
         GROUP  BY name_id,
                   NAME
         HAVING Count(DISTINCT a.movie_id) >= 5)
SELECT *,
       Dense_rank()
         OVER (
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   rank_actors; 


/* Output :
+---------------------+-------------------+---------------------+------------------------+-----------------+
| actor_name	      |	total_votes		  |	movie_count		    |	actor_avg_rating 	 |actor_rank	   |
+---------------------+-------------------+---------------------+------------------------+-----------------+
	Vijay Sethupathi		23114					5						8.42				1
	Fahadh Faasil			13557					5						7.99				2
	Yogi Babu				8500					11						7.83				3
	Joju George				3926					5						7.58				4
	Ammy Virk				2504					6						7.55				5
	Dileesh Pothan			6235					5						7.52				6
	Kunchacko Boban			5628					6						7.48				7
	Pankaj Tripathi			40728					5						7.44				8
	Rajkummar Rao			42560					6						7.37				9
	Dulquer Salmaan			17666					5						7.30				10
	Amit Sadh				13355					5						7.21				11
	Tovino Thomas			11596					8						7.15				12
	Mammootty				12613					8						7.04				13
	Nassar					4016					5						7.03				14
	Karamjit Anmol			1970					6						6.91				15
	Hareesh Kanaran			3196					5						6.58				16
	Naseeruddin Shah		12604					5						6.54				17
	Anandraj				2750					6						6.54				17
	Mohanlal				17622					7						6.47				18
	Siddique				5953					7						6.43				19
	Aju Varghese			2237					5						6.43				19
	Prakash Raj				8548					6						6.37				20
	Jimmy Sheirgill			3826					6						6.29				21
	Biju Menon				1916					5						6.21				22
	Mahesh Achanta			2716					6						6.21				22
	Suraj Venjaramoodu		4284					6						6.19				23
	Abir Chatterjee			1413					5						5.80				24
	Sunny Deol				4594					5						5.71				25
	Radha Ravi				1483					5						5.70				26
	Prabhu Deva				2044					5						5.68				27
	Atul Sharma				9604					5						4.78				28    */

-- Top actor is Vijay Sethupathi




-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)



WITH actress_summary AS
(
           SELECT     n.NAME                                                     AS actress_name,
                      Sum(total_votes)                                           AS total_votes,
                      Count(m.id)                                                AS movie_count,
                      Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
           FROM       movie                                                      AS m
           INNER JOIN ratings                                                    AS r
           ON         m.id = r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country = "INDIA"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     Count(m.id) >= 3 )
SELECT   *,
         Rank() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;


/* Output :
+--------------------+-------------------+---------------------+-------------------------+-----------------+
| actress_name	     |	total_votes		 |	movie_count		   |	actress_avg_rating 	 |actress_rank	   |
+--------------------+-------------------+---------------------+-------------------------+-----------------+
Taapsee Pannu			18061				3						7.74				1
Kriti Sanon				21967				3						7.05				2
Divya Dutta				8579				3						6.88				3
Shraddha Kapoor			26779				3						6.63				4
Kriti Kharbanda			2549				3						4.80				5					*/

/* Taapsee Pannu tops with average rating 7.74.  */






/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/


SELECT DISTINCT m.title,
                r.avg_rating,
                CASE
                  WHEN r.avg_rating > 8 THEN 'Superhit movie'
                  WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
                  WHEN r.avg_rating BETWEEN 5 AND 6.9 THEN
                  'One-time-watch movies'
                  ELSE 'Flop movie'
                END AS avg_rating_category
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  g.genre = 'thriller'
ORDER  BY m.title; 






 


-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
-- Round is good to have and not a must have; Same thing applies to sorting




SELECT g.genre                                         AS genre,
       Round(Avg(m.duration))                          AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding)    AS running_total_duration
       ,
       Round(Avg(Round(Avg(duration), 2))
               over(
                 ORDER BY genre ROWS 10 preceding), 2) AS moving_avg_duration
FROM   movie m
       inner join genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER BY Round(Avg(m.duration)) DESC ;


/* Output :
+---------------+-------------------+------------------------+------------------------+
| genre			|	avg_duration	| running_total_duration |	moving_avg_duration   |
+---------------+-------------------+------------------------+------------------------+
	Action				113					112.88					112.88
	Romance				110					1141.51					103.77
	Crime				107					424.42					106.11
	Drama				107					531.19					106.24
	Fantasy				105					737.30					105.33
	Comedy				103					317.37					105.79
	Adventure			102					214.75					107.38
	Mystery				102					931.82					103.54
	Thriller			102					1341.03					102.39
	Family				101					632.16					105.36
	Others				100					1031.98					103.20
	Sci-Fi				98					1239.45					102.42
	Horror				93					830.02					103.75  */






-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
-- Top 3 Genres based on most number of movies


WITH top_3_genre AS
(
           SELECT     genre,
                      Count(movie_id) AS number_of_movies
           FROM       genre           AS g
           INNER JOIN movie           AS m
           ON         g.movie_id = m.id
           GROUP BY   genre
           ORDER BY   Count(movie_id) DESC limit 3 ), top_5 AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      worlwide_gross_income,
                      row_number() OVER(partition BY YEAR ORDER BY worlwide_gross_income DESC) AS movie_rank
           FROM       movie                                                                    AS m
           INNER JOIN genre                                                                    AS g
           ON         m.id= g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_genre) )
SELECT *
FROM   top_5
WHERE  movie_rank<=5;

/* Output :
+---------------+-------------------+-----------------------------+---------------------------+------------------+
| genre			|	year			|	movie_name		     	  |worldwide_gross_income     |movie_rank	     |
+---------------+-------------------+-----------------------------+---------------------------+------------------+
	Drama				2017		  Shatamanam Bhavati			INR 530500000				1
	Drama				2017				Winner					INR 250000000				2
	Drama				2017		  Thank You for Your Service	$ 9995692					3
	Comedy				2017				The Healer				$ 9979800					4
	Drama				2017				The Healer				$ 9979800					5
	Thriller			2018				The Villain				INR 1300000000				1
	Drama				2018				Antony & Cleopatra		$ 998079					2
	Comedy				2018		  		La fuitina sbagliata	$ 992070					3
	Drama				2018				Zaba					$ 991						4
	Comedy				2018				Gung-hab				$ 9899017					5
	Thriller			2019				Prescience				$ 9956						1
	Thriller			2019				Joker					$ 995064593					2
	Drama				2019				Joker					$ 995064593					3
	Comedy				2019				Eaten by Lions			$ 99276						4
	Comedy				2019				Friend Zone				$ 9894885					5 */




-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?


SELECT     production_company,
           Count(m.id)                                AS movie_count,
           Row_number() OVER(ORDER BY Count(id) DESC) AS prod_comp_rank
FROM       movie                                      AS m
INNER JOIN ratings                                    AS r
ON         m.id=r.movie_id
WHERE      median_rating>=8
AND        production_company IS NOT NULL
AND        position(',' IN languages)>0
GROUP BY   production_company 
LIMIT 2;


/* Output :
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
	Star Cinema				7						1
	Twentieth Century Fox	4						2			*/








-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?


SELECT     NAME                                                    AS actress_name,
           Sum(total_votes)                                        AS total_votes,
           Count(rm.movie_id)                                      AS movie_id,
           Round(Sum(avg_rating * total_votes)/Sum(total_votes),2) AS actress_avg_rating,
           Dense_rank() OVER(ORDER BY Count(rm.movie_id) DESC)     AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN ratings r
ON         r.movie_id = rm.movie_id
INNER JOIN genre g
ON         g.movie_id = r.movie_id
WHERE      category="actress"
AND        avg_rating>8
AND        g.genre="Drama"
GROUP BY   NAME 
LIMIT 3;


/* Output :
+--------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name		 |	total_votes		 |	movie_count		   |actress_avg_rating	  |actress_rank	    |
+--------------------+-------------------+---------------------+----------------------+-----------------+
Parvathy Thiruvothu			4974				2						8.25				1
Susan Brown					656					2						8.94				1
Amanda Lawrence				656					2						8.94				1			*/





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
						*/


WITH t_date_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   t_date_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)      AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC 
LIMIT 9;



/* Output :
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
	nm2096009		Andrew Jones			5					190.75					3.02		1989			2.7				3.2			432
	nm1777967		A.L. Vijay				5					176.75					5.42		1754			3.7				6.9			613
	nm0814469		Sion Sono				4					331.00					6.03		2972			5.4				6.4			502
	nm0831321		Chris Stokes			4					198.33					4.33		3664			4.0				4.6			352
	nm0515005		Sam Liu					4					260.33					6.23		28557			5.8				6.7			312
	nm0001752		Steven Soderbergh		4					254.33					6.48		171684			6.2				7.0			401
	nm0425364		Jesse V. Johnson		4					299.00					5.45		14778			4.2				6.5			383
	nm2691863		Justin Price			4					315.00					4.50		5343			3.0				5.8			346
	nm6356309		Özgür Bakar				4					112.00					3.75		1092			3.1				4.9			374     */







