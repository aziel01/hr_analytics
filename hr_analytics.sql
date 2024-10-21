-- CLEANING: Deleting unnecessary columns --

SELECT
	*
FROM
	hr_analytics_tbl;

CREATE TABLE hr_analytics_staging
LIKE hr_analytics_tbl;

SELECT
	*
FROM
	hr_analytics_staging;
    
INSERT hr_analytics_staging
SELECT * FROM hr_analytics_tbl;

SELECT
	*
FROM 
	hr_analytics_staging;

ALTER TABLE hr_analytics_staging
DROP COLUMN EmployeeCount,
DROP COLUMN EmployeeNumber,
DROP COLUMN  Over18,
DROP COLUMN  StandardHours,
DROP COLUMN StockOptionLevel;

CREATE TABLE hr_data
LIKE hr_analytics_staging;

INSERT hr_data
SELECT * FROM hr_analytics_staging;   

SELECT * FROM hr_data;

/* ATTRITION ANALYSIS */
-- Total Employee Attrition vs Retention --

SELECT
	COUNT(*) as total_employees,
    sum(gender = 'Male') as Male,
    sum(gender = 'Female') as Female
FROM hr_data;

SELECT 
	SUM(Attrition = 'Yes') as attrition,
	SUM(Attrition = 'No') as retention
FROM hr_data;

-- Total Employees per Department--
SELECT
	Department,
    COUNT(*) as total_employees,
    sum(attrition = 'Yes') as attrition
FROM
	hr_data
GROUP by Department
ORDER BY total_employees desc;

-- Department with highest attrition --
SELECT
	Department,
    COUNT(*) as total_employees
FROM
	hr_data
WHERE attrition = 'Yes'
GROUP by Department
ORDER BY total_employees desc;

SELECT
	Department,
    Attrition
FROM 
	hr_data;

-- Attrition Rate per department --

SELECT
		Department, 
       Round(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate
FROM
	hr_data
GROUP BY Department;

/*OR*/

SELECT
	department,
    ROUND(sum(Attrition = 'Yes') * 100 / COUNT(*),2) as attrition_rate
FROM
	hr_data
GROUP BY department;

-- Gender of employees with highest attrition --
SELECT
	Department,
    COUNT(*) as total_employees,
    sum(gender = 'Male') as Male,
    sum(gender = 'Female') as Female
FROM
	hr_data
WHERE attrition = 'Yes'
GROUP by Department;

-- ATTRITION: Age group --
SELECT
	Department,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department;  

SELECT
	JobRole,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobRole;

SELECT
    JobLevel,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobLevel;

 SELECT
    JobSatisfaction,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction;
 
 SELECT
    WorkLifeBalance,
    COUNT(CASE WHEN Age BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN Age BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN Age BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN Age BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY WorkLifeBalance;

SELECT
    JobInvolvement,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobInvolvement;

    
-- ATTRITION RATE: Department and Age Group
SELECT
	Department,
ROUND(COUNT(CASE WHEN AGE BETWEEN 18 AND 25 AND Attrition = 'Yes' THEN 1 END) * 100.0 /
          NULLIF(COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END), 0), 2) as 'AttritionRate_18-25',
          
    ROUND(COUNT(CASE WHEN AGE BETWEEN 26 AND 35 AND Attrition = 'Yes' THEN 1 END) * 100.0 /
          NULLIF(COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END), 0), 2) as 'AttritionRate_26-35',
          
    ROUND(COUNT(CASE WHEN AGE BETWEEN 36 AND 45 AND Attrition = 'Yes' THEN 1 END) * 100.0 /
          NULLIF(COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END), 0), 2) as 'AttritionRate_36-45',
          
    ROUND(COUNT(CASE WHEN AGE BETWEEN 46 AND 60 AND Attrition = 'Yes' THEN 1 END) * 100.0 /
          NULLIF(COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END), 0), 2) as 'AttritionRate_46-60'    
FROM hr_data
GROUP BY Department;

-- ATTRITION: YearsAtCompany and JobLevel | Department(Sales and Research & Development) --

SELECT
	JobLevel,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as '0-10',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 11 AND 20 THEN 1 END) as '11-20',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 21 AND 30 THEN 1 END) as '21-30',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 31 AND 40 THEN 1 END) as '31-40'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY joblevel
ORDER BY JobLevel;

SELECT
	Department,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as '0-10',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 11 AND 20 THEN 1 END) as '11-20',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 21 AND 30 THEN 1 END) as '21-30',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 31 AND 40 THEN 1 END) as '31-40'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY Department;

SELECT
	JobRole,
	JobLevel,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as '0-10',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 11 AND 20 THEN 1 END) as '11-20',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 21 AND 30 THEN 1 END) as '21-30',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 31 AND 40 THEN 1 END) as '31-40'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY jobrole, joblevel
ORDER BY jobrole, JobLevel;


-- ATTRITION: By JobSatisfaction
SELECT
	JobSatisfaction,
	sum(ATTRITION='Yes') as attrition,
    sum(Attrition='No') as retention
FROM hr_data
group by JobSatisfaction
ORDER BY JobSatisfaction;

-- ATTRITION: By WorkLifeBalance --
SELECT
	WorkLifeBalance,
	sum(ATTRITION='Yes') as attrition,
    sum(Attrition='No') as retention
FROM hr_data
group by WorkLifeBalance
ORDER BY WorkLifeBalance;


-- ATTRITION: salary bracket --
SELECT
	Department,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY department;

/* EXPLORATORY DATA ANALYSIS */

-- Longest tenure Employees --
SELECT
	*
FROM
	hr_data
ORDER BY YearsAtCompany desc
LIMIT 20;

-- average work life balance --
SELECT
	Gender,
    AVG(WorkLifeBalance) AS Avg_WorkLifeBalance
FROM
	hr_data
GROUP BY Gender;

SELECT
	Education, COUNT(*) AS Promotions
FROM
	hr_data
WHERE 
	YearsSinceLastPromotion > 0
GROUP BY
	Education
ORDER BY 
	Education;

-- Average number of companies worked for employees who left  --
SELECT 
	AVG(NumCompaniesWorked) AS Avg_Num_Companies_Worked
FROM 
	hr_data
WHERE
	Attrition = 'Yes';
    
SELECT 
	AVG(YearsAtCompany),
    AVG(YearsInCurrentRole)
FROM 
	hr_data
WHERE
	Attrition = 'Yes';

    
SELECT
    JobRole,
    YearsInCurrentRole,
    count(*) as employees
FROM 
	hr_data
WHERE
	YearsInCurrentRole > 5 AND
    Attrition = 'Yes'
GROUP BY JobRole, YearsInCurrentRole;
    
-- Age Group per Department --
SELECT
	Department,
    COUNT(CASE WHEN AGE BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN AGE BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN AGE BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN AGE BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
GROUP BY Department;


/* JOB SATISFACTION */

-- Department | Job Satisfaction | EmployeeCount | JobLevel --
SELECT
	department,
    COUNT(CASE WHEN JobSatisfaction = 1 THEN 1 END) as '1',
    COUNT(CASE WHEN JobSatisfaction = 2 THEN 1 END) as '2',
    COUNT(CASE WHEN JobSatisfaction = 3 THEN 1 END) as '3',
    COUNT(CASE WHEN JobSatisfaction = 4 THEN 1 END) as '4'
FROM hr_data
GROUP BY department;

SELECT
	JobLevel,
    SUM(JobSatisfaction = '1') as Bad,
    SUM(JobSatisfaction = '2') as Good,
    SUM(JobSatisfaction = '3') as Better,
    SUM(JobSatisfaction = '4') as Best
FROM hr_data
GROUP BY JobLevel;

-- OR --


SELECT
    Department,
    JobSatisfaction,
    COUNT(*) AS EmployeeCount
FROM
    hr_data
GROUP BY
    Department,
    JobSatisfaction
ORDER BY
    Department, 
    JobSatisfaction;
    
-- JOB SATISFACTION: Job role --

SELECT 
	JobRole,
    JobSatisfaction,
    COUNT(JobSatisfaction) as count
FROM hr_data
GROUP BY JobRole, JobSatisfaction
ORDER BY count desc;

-- JOB SATISFACTION: Job role with Overtime --
SELECT 
	JobRole,
    JobSatisfaction,
    COUNT(OverTime) as with_OverTime
FROM hr_data
WHERE OverTime = 'Yes' AND JobSatisfaction < 3
GROUP BY JobRole, JobSatisfaction
order by with_Overtime desc
LIMIT 5;

/* SELECT 
    JobSatisfaction, 
    AVG(WorkLifeBalance) AS Avg_WorkLifeBalance,
    AVG(MonthlyIncome) AS Avg_Income,
    AVG(YearsAtCompany) AS Avg_YearsAtCompany,
    AVG(EnvironmentSatisfaction) AS Avg_EnvironmentSatisfaction,
    AVG(RelationshipSatisfaction) AS Avg_RelationshipSatisfaction,
    COUNT(*) AS EmployeeCount
FROM 
    hr_data
GROUP BY 
    JobSatisfaction
ORDER BY 
    JobSatisfaction;
*/

-- JOB SATISFACTION LEVEL: Department and EmployeeCount --
SELECT
	department,
    COUNT(CASE WHEN JobSatisfaction = 1 THEN 1 END) as '1',
    COUNT(CASE WHEN JobSatisfaction = 2 THEN 1 END) as '2',
    COUNT(CASE WHEN JobSatisfaction = 3 THEN 1 END) as '3',
    COUNT(CASE WHEN JobSatisfaction = 4 THEN 1 END) as '4'
FROM hr_data
GROUP BY department;
    
SELECT
	EnvironmentSatisfaction,
    COUNT(CASE WHEN JobSatisfaction = 1 THEN 1 END) as '1',
    COUNT(CASE WHEN JobSatisfaction = 2 THEN 1 END) as '2',
    COUNT(CASE WHEN JobSatisfaction = 3 THEN 1 END) as '3',
    COUNT(CASE WHEN JobSatisfaction = 4 THEN 1 END) as '4'
FROM hr_data
GROUP BY EnvironmentSatisfaction;

-- JOB SATISFACTION: FACTORS --
SELECT 
	JobSatisfaction,
    SUM(WorkLifeBalance = '1') as 'Bad',
    SUM(WorkLifeBalance = '2') as 'Good',
    SUM(WorkLifeBalance = '3') as 'Better',
    SUM(WorkLifeBalance = '4') as 'Best'
FROM hr_data
GROUP BY JobSatisfaction
ORDER by JobSatisfaction;

SELECT 
	JobSatisfaction,
    SUM(JobInvolvement = '1') as 'Low',
    SUM(JobInvolvement= '2') as 'Medium',
    SUM(JobInvolvement = '3') as 'High',
    SUM(JobInvolvement = '4') as 'Very High'
FROM hr_data
GROUP BY JobSatisfaction
ORDER by JobSatisfaction;

SELECT 
	JobSatisfaction,
    SUM(EnvironmentSatisfaction = '1') as 'Bad',
    SUM(EnvironmentSatisfaction = '2') as 'Good',
    SUM(EnvironmentSatisfaction = '3') as 'Better',
    SUM(EnvironmentSatisfaction = '4') as 'Best'
FROM hr_data
GROUP BY JobSatisfaction
ORDER by JobSatisfaction;

-- JOB SATISFACTION: Job Role (better) --
SELECT 
	JobRole,
    SUM(JobSatisfaction = '1') as 'Bad',
    SUM(JobSatisfaction = '2') as 'Good',
    SUM(JobSatisfaction = '3') as 'Better',
    SUM(JobSatisfaction = '4') as 'Best'
FROM hr_data
WHERE Department LIKE '%Research%'
GROUP BY JobRole
ORDER by JobRole;

SELECT 
	Department,
    SUM(JobSatisfaction = '1') as 'Bad',
    SUM(JobSatisfaction = '2') as 'Good',
    SUM(JobSatisfaction = '3') as 'Better',
    SUM(JobSatisfaction = '4') as 'Best'
FROM hr_data
GROUP BY Department
ORDER by Department;


SELECT
	JobRole,
	SUM(WorkLifeBalance = '1') as 'Bad',
    SUM(WorkLifeBalance = '2') as 'Good',
    SUM(WorkLifeBalance = '3') as 'Better',
    SUM(WorkLifeBalance = '4') as 'Best'
FROM hr_data
GROUP BY JobRole
ORDER BY JobRole;

SELECT
	PerformanceRating,
	SUM(WorkLifeBalance = '1') as 'Bad',
    SUM(WorkLifeBalance = '2') as 'Good',
    SUM(WorkLifeBalance = '3') as 'Better',
    SUM(WorkLifeBalance = '4') as 'Best'
FROM hr_data
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

-- JOB SATISFACTION: By JobRole and Salary bracket(monthly income) --
SELECT
	JobSatisfaction,
    COUNT(CASE WHEN MonthlyRate BETWEEN 2000 AND 5000 THEN 1 END) as '2000-5000',
    COUNT(CASE WHEN MonthlyRate BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyRate BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyRate BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000',
    COUNT(CASE WHEN MonthlyRate BETWEEN 20001 AND 27000 THEN 1 END) as '20001-27000'
FROM hr_data
WHERE attrition = 'Yes'
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


SELECT
	JobRole,
    JobSatisfaction,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
GROUP BY JobRole, JobSatisfaction
ORDER BY JobRole, JobSatisfaction;

SELECT
	JobSatisfaction,
    Attrition,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
GROUP BY JobSatisfaction, Attrition
ORDER BY JobSatisfaction;

-- JOB SATISFACTION: Work life balance by JobRole and Salary bracket
SELECT
	JobRole,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
GROUP BY JobRole
ORDER BY JobRole;

SELECT
	Joblevel,
    Attrition,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
GROUP BY JobLevel, Attrition
ORDER BY JobLevel;

SELECT
	JobLevel,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 5 THEN 1 END) as '0-5 years',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 6 AND 10 THEN 1 END) as '6-10 years',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as 'total_employees'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY joblevel
ORDER BY JobLevel;

SELECT
	Department,
    SUM(JobSatisfaction = '1') as Bad,
    SUM(JobSatisfaction = '2') as Good,
    SUM(JobSatisfaction = '3') as Better,
    SUM(JobSatisfaction = '4') as Best
FROM hr_data
GROUP BY Department;

-- AVERAGE JOB SATISFACTION OVERALL--
SELECT
	ROUND(AVG(Bad),2),
    ROUND(AVG(Good),2),
    ROUND(AVG(BETTER),2),
    ROUND(AVG(BEST),2)
FROM 
(
SELECT
	Department,
    SUM(JobSatisfaction = '1') as Bad,
    SUM(JobSatisfaction = '2') as Good,
    SUM(JobSatisfaction = '3') as Better,
    SUM(JobSatisfaction = '4') as Best
FROM hr_data
GROUP BY Department
) as sub_query;

-- JOB ROLE, DEPARTMENT and JOB INVOLVEMENT LEVEL --    
SELECT
	JobRole,
	SUM(JobInvolvement = '1')  as 'Low',
    SUM(JobInvolvement= '2') as 'Medium',
    SUM(JobInvolvement = '3') as 'High',
    SUM(JobInvolvement = '4') as 'Very High'
FROM hr_data
WHERE attrition = 'Yes'
GROUP BY JobRole;

SELECT
	Department,
	SUM(JobInvolvement = '1') as 'Low',
    SUM(JobInvolvement= '2') as 'Medium',
    SUM(JobInvolvement = '3') as 'High',
    SUM(JobInvolvement = '4') as 'Very High'
FROM hr_data
GROUP BY Department;

SELECT
	Department,
	ROUND(SUM(JobInvolvement = '1') * 100.0 / COUNT(*), 2) AS 'Low',
    ROUND(SUM(JobInvolvement = '2') * 100.0 / COUNT(*), 2) AS 'Medium',
    ROUND(SUM(JobInvolvement = '3') * 100.0 / COUNT(*), 2) AS 'High',
    ROUND(SUM(JobInvolvement = '4') * 100.0 / COUNT(*), 2) AS 'Very_High'
FROM hr_data
GROUP BY Department;

/* Finalizing Queries */

SELECT
	Department,
    COUNT(*) as total_employees,
    sum(attrition = 'Yes') as attrition,
    sum(attrition = 'No') as retention
FROM
	hr_data
GROUP by Department
ORDER BY total_employees desc;

SELECT
	Department,
    JobRole,
    JobLevel,
    COUNT(CASE WHEN Age BETWEEN 18 AND 25 THEN 1 END) as '18-25',
	COUNT(CASE WHEN Age BETWEEN 26 AND 35 THEN 1 END) as '26-35',
    COUNT(CASE WHEN Age BETWEEN 36 AND 45 THEN 1 END) as '36-45',
    COUNT(CASE WHEN Age BETWEEN 46 AND 60 THEN 1 END) as '46-60'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department, JobRole, JobLevel
ORDER BY Department;  

SELECT
	JobLevel,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as '0-10',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 11 AND 20 THEN 1 END) as '11-20',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 21 AND 30 THEN 1 END) as '21-30',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 31 AND 40 THEN 1 END) as '31-40'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY joblevel
ORDER BY JobLevel;

SELECT
	JobLevel,
	COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 5 THEN 1 END) as '0-5 years',
	COUNT(CASE WHEN YearsAtCompany BETWEEN 6 AND 10 THEN 1 END) as '6-10 years',
    COUNT(CASE WHEN YearsAtCompany BETWEEN 0 AND 10 THEN 1 END) as 'total_employees'
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY joblevel
ORDER BY JobLevel;

SELECT 
 jobsatisfaction,
 count(*) as 'Retention'
FROM  
	hr_data
WHERE
	Attrition = 'No'
GROUP BY 
	JobSatisfaction;
    
SELECT
    Department,
	JobRole,
    COUNT(CASE WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN 1 END) as '1000-5000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 5001 AND 10000 THEN 1 END) as '5001-10000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 10001 AND 15000 THEN 1 END) as '10001-15000',
    COUNT(CASE WHEN MonthlyIncome  BETWEEN 15001 AND 20000 THEN 1 END) as '15001-20000'
FROM hr_data
GROUP BY  Department,JobRole
ORDER BY JobRole;


SELECT
	YearsSinceLastPromotion,
	COUNT(CASE WHEN education = '1' THEN 1 END) as 'Below College',
    COUNT(CASE WHEN education = '2' THEN 1 END) as 'College',
    COUNT(CASE WHEN education = '3' THEN 1 END) as 'Bachelor',
    COUNT(CASE WHEN education = '4' THEN 1 END) as 'Master',
    COUNT(CASE WHEN education = '5' THEN 1 END) as 'Doctor'
FROM hr_data
GROUP BY  YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion
LIMIT 11;

SELECT
	sum(attrition = 'Yes')*100/count(*) as average_attrition
FROM hr_data