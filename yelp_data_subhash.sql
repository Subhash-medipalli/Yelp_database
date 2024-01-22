
/* This SQL Script loads the following tables
businesses, user_activity, business_attributes,business_categories
BUSINESSHOURS, REVIEWS, TIPS, USERELITEYEARS
*/

/* Create table businesses with the given attributes */
CREATE TABLE businesses (
    business_id  VARCHAR(22) primary key,
    business_name VARCHAR(250),
    street_address VARCHAR(250),
    city VARCHAR(250),
    state CHAR(3),
    postal_code CHAR(9),
    latitude NUMERIC(9, 7),
    longitude NUMERIC(10, 7),
    average_star_reviews NUMERIC(3, 1),
    average_reviews INT,
    is_open INTEGER,
    CONSTRAINT average_star_reviews_check CHECK (average_star_reviews >= 0.0 AND average_star_reviews <= 5.0),
    CONSTRAINT is_open_check CHECK (is_open = ANY (ARRAY[0, 1]))
);



/*Create table users_activity with user_id as primary key */
CREATE TABLE user_activity (
    user_id VARCHAR(22) PRIMARY KEY,
    name VARCHAR(260),
    num_reviews_left INTEGER,
    join_date TIMESTAMP WITHOUT TIME ZONE,
    useful_votes_sent INTEGER,
    funny_votes_sent INTEGER,
    cool_votes_sent INTEGER,
    num_fans INTEGER,
    avg_rating DECIMAL(3, 2),
    hot_compliments_received INTEGER,
    more_compliments_received INTEGER,
    profile_compliments_received INTEGER,
    cute_compliments_received INTEGER,
    list_compliments_received INTEGER,
    note_compliments_received INTEGER,
    plain_compliments_received INTEGER,
    cool_compliments_received INTEGER,
    funny_compliments_received INTEGER,
    writer_compliments_received INTEGER,
    photo_compliments_received INTEGER,
    CONSTRAINT avg_rating_check CHECK (avg_rating >= 0.0 AND avg_rating <= 5.0)
);



/* Create table business_attributes with business_id as foreign key*/
CREATE TABLE business_attributes (
    business_id VARCHAR(22),
    attribute_name VARCHAR(260), 
    attribute_value VARCHAR(260), 
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)
);


/* Create table business_categories with business_id as foreign key*/

CREATE TABLE business_categories(
    business_id VARCHAR(22),
    category_name VARCHAR(260), 
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)

);


/*Create table Business_hours with with business_id as foreign key*/
CREATE TABLE business_hours (
    business_id VARCHAR(22),
    day_of_week VARCHAR(50), 
    opening_time TIME WITHOUT TIME ZONE,
    closing_time TIME WITHOUT TIME ZONE,
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)
);


/*Create table reviews with review_id as primary key and  business_id as foreign key*/
CREATE TABLE reviews (
    review_id VARCHAR(22) PRIMARY KEY,
    user_id VARCHAR(22),
    business_id VARCHAR(22),
    user_rating NUMERIC(3, 1),
    useful_count INTEGER,
    funny_count INTEGER,
    cool_count INTEGER,
    review_text TEXT,
    review_datetime TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (business_id) REFERENCES businesses(business_id),
    CONSTRAINT user_rating_check CHECK (user_rating >= 0.0 AND user_rating <= 5.0)
);

/*Create table tips with both user_id and business_id as foreign key*/ 
CREATE TABLE tips (
    user_id VARCHAR(22) ,
    business_id VARCHAR(22),
    tip_text TEXT,
    tip_date_time TIMESTAMP WITHOUT TIME ZONE,
    num_compliments INTEGER,
    FOREIGN KEY (business_id) REFERENCES businesses(business_id),
    FOREIGN KEY (user_id) REFERENCES user_activity(user_id)
);

/*Create table usereliteyears with user_id */

create table user_elite_years (
    user_id VARCHAR(22),
    year INTEGER,
    FOREIGN KEY (user_id) REFERENCES user_activity(user_id)

);
