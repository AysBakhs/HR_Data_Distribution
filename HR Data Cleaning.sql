CREATE DATABASE projects;

USE projects;

Select  * From hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL; 

DESCRIBE hr;

Select birthdate From hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT birthdate FROM hr;

UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;
    
    ALTER TABLE hr MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = DATE_FORMAT(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'), '%Y-%m-%d')
WHERE termdate IS NOT NULL;

SELECT termdate FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate Date;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 21;

-- 1. What is th gender breakdown of employees in the company?

SELECT gender, count(*) AS count
From hr
WHERE age>=18 
Group by gender;

-- 2. What is the race/etnicity breakdown of employees in the company?

SELECT race, count(*) AS count 
FROM hr 
WHERE age >= 18
Group BY race
ORDER BY count desc;

-- 3.What is the age distribution of employees in the company?
SELECT 
	min(age) AS youngest,
    max(age) as oldest
FROM hr
WHERE age >= 18;

SELECT 
 CASE 
	WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
	WHEN age >= 55 AND age <= 64 THEN '55-64'
  ELSE '65+'
  END AS age_group,gender,
  count(*) AS count
  from hr
  where age >= 18 
  GROUP BY age_group, gender
  ORDER BY age_group, gender;
    
-- 4.How many employees work at headquarters versus remote locations?

SELECT location, count(*) AS count
FROM hr
WHERE AGE >= 18
GROUP BY location;

-- 5.What is the average length of employment for employees who have been terminated?

SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18;

-- 6.How does the gender distribution vary across departments and job titles?
SELECT  department, gender, count(*) count
FROM hr
WHERE age >= 18
Group by department, gender
order by department;

-- 7.What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8.Which department has the highest turnover rate?


SELECT department, 
       COUNT(*) as total_count, 
       SUM(CASE WHEN termdate <= CURDATE() AND termdate IS NOT NULL THEN 1 ELSE 0 END) as terminated_count, 
       SUM(CASE WHEN termdate IS NULL THEN 1 ELSE 0 END) as active_count,
       (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;




-- 9.What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

-- 10.How has the company's employee count changed over time based on hire and term dates?

    SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100), 2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
-- 11. What is the tenure distribution for each department?

SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365), 0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL AND age >= 18
GROUP BY department;

   
    