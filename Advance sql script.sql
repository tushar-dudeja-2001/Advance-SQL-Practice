-- Connect to database (MySQL)
USE maven_advanced_sql;

-- 1. View the students table
SELECT * FROM students;

-- 2. The big 6
SELECT	grade_level, AVG(gpa) AS avg_gpa
FROM	students
WHERE	school_lunch = 'Yes'
GROUP BY grade_level
HAVING   avg_gpa < 3.3
ORDER BY grade_level;

-- 3. Common keywords

-- DISTINCT
SELECT	DISTINCT grade_level
FROM	students;

-- COUNT
SELECT	COUNT(DISTINCT grade_level)
FROM	students;

-- MAX and MIN
SELECT	MAX(gpa) - MIN(gpa) AS gpa_range
FROM	students;

-- AND
SELECT	*
FROM	students
WHERE	grade_level < 12 AND school_lunch = 'Yes';

-- IN
SELECT	*
FROM	students
WHERE	grade_level IN (9, 10, 11);

-- IS NULL
SELECT	*
FROM	students
WHERE	email IS NOT NULL;

-- LIKE
SELECT	*
FROM	students
WHERE	email LIKE '%.edu';

-- ORDER BY
SELECT	*
FROM	students
ORDER BY gpa DESC;

-- LIMIT
SELECT	*
FROM	students
LIMIT	5;

-- CASE statements
SELECT	student_name, grade_level,
		CASE WHEN grade_level = 9 THEN 'Freshman'
			 WHEN grade_level = 10 THEN 'Sophomore'
             WHEN grade_level = 11 THEN 'Junior'
             ELSE 'Senior' END AS student_class
FROM	students;


-- -----------------------------------------------------------------------------------

-- 1. Basic joins
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;

SELECT	happiness_scores.year, happiness_scores.country, happiness_scores.happiness_score,
		country_stats.continent
FROM	happiness_scores
		INNER JOIN country_stats
        ON happiness_scores.country = country_stats.country;
        
SELECT	hs.year, hs.country, hs.happiness_score,
		cs.continent
FROM	happiness_scores hs
		INNER JOIN country_stats cs
        ON hs.country = cs.country;

-- 2. Join types
SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		INNER JOIN country_stats cs
        ON hs.country = cs.country;
        
SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	cs.country IS NULL;

SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		RIGHT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	hs.country IS NULL;

SELECT	DISTINCT hs.country
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	cs.country IS NULL;

SELECT	DISTINCT cs.country
FROM	happiness_scores hs
		RIGHT JOIN country_stats cs
        ON hs.country = cs.country
WHERE	hs.country IS NULL;
        
-- 3. Joining on multiple columns
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;
SELECT * FROM inflation_rates;

SELECT	*
FROM	happiness_scores hs
		INNER JOIN inflation_rates ir
        ON hs.country = ir.country_name AND hs.year = ir.year;
        
-- 4. Joining multiple tables
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;
SELECT * FROM inflation_rates;

SELECT	hs.year, hs.country, hs.happiness_score,
		cs.continent, ir.inflation_rate
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
			ON hs.country = cs.country
		LEFT JOIN inflation_rates ir
			ON hs.year = ir.year AND hs.country = ir.country_name;

-- 5. Self joins
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
	(1, 'Ava', 85000, NULL),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2);
    
SELECT * FROM employees;

-- Employees with the same salary
SELECT	e1.employee_id, e1.employee_name, e1.salary,
		e2.employee_id, e2.employee_name, e2.salary
FROM	employees e1 INNER JOIN employees e2
		ON e1.salary = e2.salary
WHERE	e1.employee_id > e2.employee_id;

-- Employees that have a greater salary
SELECT	e1.employee_id, e1.employee_name, e1.salary, 
		e2.employee_id, e2.employee_name, e2.salary
FROM	employees e1 INNER JOIN employees e2
		ON e1.salary > e2.salary
ORDER BY e1.employee_id;

-- Employees and their managers
SELECT	e1.employee_id, e1.employee_name, e1.manager_id,
		e2.employee_name AS manager_name
FROM	employees e1 LEFT JOIN employees e2
		ON e1.manager_id = e2.employee_id;
        
-- 6. Cross joins
CREATE TABLE tops (
    id INT,
    item VARCHAR(50)
);

CREATE TABLE sizes (
    id INT,
    size VARCHAR(50)
);

CREATE TABLE outerwear (
    id INT,
    item VARCHAR(50)
);

INSERT INTO tops (id, item) VALUES
	(1, 'T-Shirt'),
	(2, 'Hoodie');

INSERT INTO sizes (id, size) VALUES
	(101, 'Small'),
	(102, 'Medium'),
	(103, 'Large');

INSERT INTO outerwear (id, item) VALUES
	(2, 'Hoodie'),
	(3, 'Jacket'),
	(4, 'Coat');
    
-- View the tables
SELECT * FROM tops;
SELECT * FROM sizes;
SELECT * FROM outerwear;

-- Cross join the tables
SELECT	*
FROM	tops CROSS JOIN sizes;

-- From the self join assignment:
-- Which products are within 25 cents of each other in terms of unit price?
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM	products p1 INNER JOIN products p2
		ON p1.product_id <> p2.product_id
WHERE	ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;
        
-- Rewritten with a CROSS JOIN
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM	products p1 CROSS JOIN products p2
WHERE	ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;

-- 7. Union vs union all
SELECT * FROM tops;
SELECT * FROM outerwear;

-- Union
SELECT * FROM tops
UNION
SELECT * FROM outerwear;

-- Union all
SELECT * FROM tops
UNION ALL
SELECT * FROM outerwear;

-- Union with different column names
SELECT * FROM happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;

-- ---------------------------------------------------------------------------------------------------

-- 1. Subqueries in the SELECT clause
SELECT * FROM happiness_scores;

-- Average happiness score
SELECT AVG(happiness_score) FROM happiness_scores;

-- Happiness score deviation from the average
SELECT	year, country, happiness_score,
		(SELECT AVG(happiness_score) FROM happiness_scores) AS avg_hs,
        happiness_score - (SELECT AVG(happiness_score) FROM happiness_scores) AS diff_from_avg
FROM	happiness_scores;

-- 2. Subqueries in the FROM clause
SELECT * FROM happiness_scores;

-- Average happiness score for each country
SELECT	 country, AVG(happiness_score) AS avg_hs_by_country
FROM	 happiness_scores
GROUP BY country;

/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */
SELECT	hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
FROM	happiness_scores hs LEFT JOIN
		(SELECT	 country, AVG(happiness_score) AS avg_hs_by_country
		 FROM	 happiness_scores
		 GROUP BY country) AS country_hs
		ON hs.country = country_hs.country;
            
-- View one country
SELECT	hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
FROM	happiness_scores hs LEFT JOIN
		(SELECT	 country, AVG(happiness_score) AS avg_hs_by_country
		 FROM	 happiness_scores
		 GROUP BY country) AS country_hs
		ON hs.country = country_hs.country
WHERE	hs.country = 'United States';
            
-- 3. Multiple subqueries

-- Return happiness scores for 2015 - 2024
SELECT DISTINCT year FROM happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;
            
/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */
SELECT	hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
FROM	(SELECT year, country, happiness_score FROM happiness_scores
		 UNION ALL
		 SELECT 2024, country, ladder_score FROM happiness_scores_current) AS hs
         LEFT JOIN
		(SELECT	 country, AVG(happiness_score) AS avg_hs_by_country
		 FROM	 happiness_scores
		 GROUP BY country) AS country_hs
		ON hs.country = country_hs.country;
       
/* Return years where the happiness score is a whole point
greater than the country's average happiness score */
SELECT * FROM

(SELECT	hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
FROM	(SELECT year, country, happiness_score FROM happiness_scores
		 UNION ALL
		 SELECT 2024, country, ladder_score FROM happiness_scores_current) AS hs
         LEFT JOIN
		(SELECT	 country, AVG(happiness_score) AS avg_hs_by_country
		 FROM	 happiness_scores
		 GROUP BY country) AS country_hs
		ON hs.country = country_hs.country) AS hs_country_hs
        
WHERE happiness_score > avg_hs_by_country + 1;

-- 4. Subqueries in the WHERE and HAVING clauses

-- Average happiness score
SELECT AVG(happiness_score) FROM happiness_scores;

-- Above average happiness scores (WHERE)
SELECT	*
FROM	happiness_scores
WHERE	happiness_score > (SELECT AVG(happiness_score) FROM happiness_scores);

-- Above average happiness scores for each region (HAVING)
SELECT	 region, AVG(happiness_score) AS avg_hs
FROM	 happiness_scores
GROUP BY region
HAVING	 avg_hs > (SELECT AVG(happiness_score) FROM happiness_scores);

-- 5. ANY vs ALL
SELECT * FROM happiness_scores; -- 2015-2023
SELECT * FROM happiness_scores_current; -- 2024

-- Scores that are greater than ANY 2024 scores
SELECT 	COUNT(*)
FROM 	happiness_scores
WHERE	happiness_score > 
		ANY(SELECT  ladder_score
			FROM	happiness_scores_current);
            
SELECT 	COUNT(*)
FROM 	happiness_scores;

-- Scores that are greater than ALL 2024 scores
SELECT 	*
FROM 	happiness_scores
WHERE	happiness_score > 
		ALL(SELECT  ladder_score
			FROM	happiness_scores_current);

-- 6. EXISTS
SELECT * FROM happiness_scores;
SELECT * FROM inflation_rates;

/* Return happiness scores of countries
that exist in the inflation rates table */
SELECT	*
FROM 	happiness_scores h
WHERE	EXISTS (
		SELECT	i.country_name
        FROM	inflation_rates i
        WHERE	i.country_name = h.country);

-- Alternative to EXISTS: INNER JOIN
SELECT	*
FROM 	happiness_scores h
		INNER JOIN inflation_rates i
        ON h.country = i.country_name AND h.year = i.year;
     
-- -----------------------------------------------------------------------------------------------

-- 1. Window function basics

-- Return all row numbers
SELECT	 country, year, happiness_score,
		 ROW_NUMBER() OVER() AS row_num
FROM	 happiness_scores
ORDER BY country, year;

-- Return all row numbers within each window
SELECT	 country, year, happiness_score,
		 ROW_NUMBER() OVER(PARTITION BY country) AS row_num
FROM	 happiness_scores
ORDER BY country, year;

-- Return all row numbers within each window
-- where the rows are ordered by happiness score
SELECT	 country, year, happiness_score,
		 ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score) AS row_num
FROM	 happiness_scores
ORDER BY country, row_num;

-- Return all row numbers within each window
-- where the rows are ordered by happiness score descending
SELECT	 country, year, happiness_score,
		 ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score DESC) AS row_num
FROM	 happiness_scores
ORDER BY country, row_num;

-- 2. ROW_NUMBER vs RANK vs DENSE_RANK
CREATE TABLE baby_girl_names (
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_girl_names (name, babies) VALUES
	('Olivia', 99),
	('Emma', 80),
	('Charlotte', 80),
	('Amelia', 75),
	('Sophia', 72),
	('Isabella', 70),
	('Ava', 70),
	('Mia', 64);
    
-- View the table
SELECT * FROM baby_girl_names;

-- Compare ROW_NUMBER vs RANK vs DENSE_RANK
SELECT	name, babies,
		ROW_NUMBER() OVER(ORDER BY babies DESC) AS babies_rn,
        RANK() OVER(ORDER BY babies DESC) AS babies_rank,
        DENSE_RANK() OVER(ORDER BY babies DESC) AS babies_drank
FROM	baby_girl_names;

-- 3. FIRST_VALUE, LAST VALUE & NTH_VALUE
CREATE TABLE baby_names (
    gender VARCHAR(10),
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_names (gender, name, babies) VALUES
	('Female', 'Charlotte', 80),
	('Female', 'Emma', 82),
	('Female', 'Olivia', 99),
	('Male', 'James', 85),
	('Male', 'Liam', 110),
	('Male', 'Noah', 95);
    
-- View the table
SELECT * FROM baby_names;
    
-- Return the first name in each window
SELECT	gender, name, babies,
		FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM	baby_names;
    
-- Return the top name for each gender
SELECT * FROM

(SELECT	gender, name, babies,
		FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM	baby_names) AS top_name

WHERE name = top_name;

-- CTE alternative
WITH top_name AS
(SELECT	gender, name, babies,
		FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies DESC) AS top_name
FROM	baby_names) 

SELECT * 
FROM top_name
WHERE name = top_name;

-- Return the second name in each window
SELECT	gender, name, babies,
		NTH_VALUE(name, 2) OVER(PARTITION BY gender ORDER BY babies DESC) AS second_name
FROM	baby_names;

-- Return the 2nd most popular name for each gender
SELECT * FROM

(SELECT	gender, name, babies,
		NTH_VALUE(name, 2) OVER(PARTITION BY gender ORDER BY babies DESC) AS second_name
FROM	baby_names) AS second_name

WHERE name = second_name;

-- Alternative using ROW_NUMBER

-- Number all the rows within each window
SELECT	gender, name, babies,
		ROW_NUMBER() OVER(PARTITION BY gender ORDER BY babies DESC) AS popularity
FROM	baby_names;

-- Return the top 2 most popular names for each gender
SELECT * FROM

(SELECT	gender, name, babies,
		ROW_NUMBER() OVER(PARTITION BY gender ORDER BY babies DESC) AS popularity
FROM	baby_names) AS pop

WHERE popularity <= 2;

-- 4. LEAD & LAG

-- Return the prior year's happiness score
SELECT	country, year, happiness_score,
		LAG(happiness_score) OVER(PARTITION BY country ORDER BY year) AS prior_happiness_score
FROM	happiness_scores;

-- Return the difference between yearly scores
WITH hs_prior AS (SELECT	country, year, happiness_score,
							LAG(happiness_score) OVER(PARTITION BY country ORDER BY year)
                            AS prior_happiness_score
				  FROM		happiness_scores)
                  
SELECT  country, year, happiness_score, prior_happiness_score,
		happiness_score - prior_happiness_score AS hs_change
FROM	hs_prior;

-- 5. NTILE

-- Add a percentile to each row of data
SELECT	region, country, happiness_score,
		NTILE(4) OVER(PARTITION BY region ORDER BY happiness_score DESC) AS hs_percentile
FROM	happiness_scores
WHERE	year = 2023
ORDER BY region, happiness_score DESC;

-- For each region, return the top 25% of countries, in terms of happiness score
WITH hs_pct AS (SELECT	region, country, happiness_score,
						NTILE(4) OVER(PARTITION BY region ORDER BY happiness_score DESC)
                        AS hs_percentile
				FROM	happiness_scores
				WHERE	year = 2023
				ORDER BY region, happiness_score DESC)

			/* This ORDER BY clause in the CTE doesn't affect the final order of
			the query and can be removed to make the code run more efficiently */
                
SELECT	*
FROM	hs_pct
WHERE	hs_percentile = 1;
