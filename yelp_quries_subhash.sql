

/*How many users have joined Yelp each year since 2010?*/

->  select extract(year from join_date) as join_year, count(*) as user_count from 
	user_activity where extract(year from join_date) >= 2010 group by join_year order by join_year;

/* How many users were elite in each of the 10 years from 2012 through 2021? Does it look like the number of elite users is increasing, decreasing, or staying about the same?*/
->  select year, count(*) as elite_user_count from user_elite_years where 
	year between 2012 and 2021 group by year order by year;

/*Which of our users has the most 5-star reviews of all time? Give us the person’s name, when they joined Yelp, how many fans they have, how many funny, useful, and cool ratings they’ve gotten. Please also gives us 3-5 examples of recent 5-star reviews they have written.*/
->  SELECT 
    ua.name, ua.join_date, ua.num_fans,
	COUNT(CASE WHEN r.user_rating = 5 THEN 1 END) AS num_of_5_star_reviews,
    SUM(r.useful_count) AS useful_count,
  	SUM(r.funny_count) AS funny_count,
  	SUM(r.cool_count ) AS cool_count,
    STRING_AGG(r.review_text, '; ') 
	FROM user_activity ua join reviews r on ua.user_id = r.user_id
	GROUP BY ua.name, ua.join_date, ua.num_fans
	ORDER BY num_of_5_star_reviews DESC LIMIT 5;


-> /* As we don't have friends database no way to getting data. */

/*Which US states have the most businesses in our database? Give us the top 10 states.*/


->  SELECT state, COUNT(*) AS number_of_businesses
	FROM businesses
	GROUP BY state
	ORDER BY number_of_businesses DESC
	LIMIT 10;

/*What are our top ten business categories? In other words, which 10 categories have the most businesses assigned to them?*/

->  SELECT category_name, COUNT(*) AS number_of_businesses
	FROM business_categories
	GROUP BY category_name
	ORDER BY number_of_businesses DESC
	LIMIT 10;

/*What is the average rating of the businesses in each of those top ten categories?*/

->	SELECT COUNT(*) as businesses_count, category_name,avg(average_star_reviews) as average
	FROM business_categories bc
	join businesses b on bc.business_id = b.business_id
	GROUP BY category_name
	ORDER BY businesses_count DESC
	LIMIT 10;

/* We think the compliments that tips receive are mostly based on how long the tip is. Can you compare the average length of the tip text for the 100 most-complimented tips with the average length of the 100 least-complimented tips and tell us if that seems to be true? (Hint: you will need to use computed properties to answer this question).*/

->	/* least funny */
with restaurants as 
(select business_id from business_categories where category_name='Restaurants')

select funny_count,review_text from reviews where business_id in (select business_id from restaurants)
order by funny_count limit 20;

/* most funny */
with restaurants as (select business_id from business_categories
where category_name='Restaurants')

select funny_count,review_text from reviews where business_id in (select business_id from restaurants)
order by funny_count desc limit 20;


/* We think the compliments that tips receive are mostly based on how long the tip is. Can you compare the average length of the tip text for the 100 most-complimented tips with the average length of the 100 least-complimented tips and tell us if that seems to be true? (Hint: you will need to use computed properties to answer this question).*/

->	SELECT 
    (SELECT AVG(LENGTH(tip_text)) 
     FROM (SELECT tip_text FROM tips ORDER BY num_compliments DESC LIMIT 100) AS most_complimented) 
     AS avg_length_most_complimented,
     
    (SELECT AVG(LENGTH(tip_text)) 
     FROM (SELECT tip_text FROM tips WHERE num_compliments > 0 ORDER BY num_compliments ASC, tip_date_time DESC LIMIT 100) AS least_complimented) 
     AS avg_length_least_complimented;

/* We are trying to figure out whether restaurant reviews are driven mostly by price range, how many hours the restaurant is open, or the days they are open. Can you please give us a spreadsheet with the data we need to answer that question? (Note from Professor Augustyn: You don’t actually have to hand in a spreadsheet…just give me a table with 10 rows of sample data returned by your query.)*/

->	SELECT r.business_id, bc.category_name, bh.day_of_week, bh.opening_time, bh.closing_time,
	EXTRACT(EPOCH FROM (bh.closing_time - bh.opening_time))/3600 AS hours_open,
	r.user_rating, r.useful_count, r.funny_count, r.cool_count, r.review_text
	FROM reviews r 
	JOIN business_categories bc ON r.business_id = bc.business_id
	JOIN business_hours bh ON bc.business_id = bh.business_id
	WHERE bc.category_name = 'Restaurants' 
	ORDER BY r.user_rating DESC, r.review_datetime DESC 
	LIMIT 10;





