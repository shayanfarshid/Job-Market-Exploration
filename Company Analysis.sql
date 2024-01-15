-- Appendix: For loading ALL Data
SELECT 
    j.job_id,
    cd.company_name,
    cd.industry,
    j.title,
    j.description AS job_description,
    sr.min_salary,
    sr.max_salary,
    l.location_name,
    wt.work_type_name,
    el.experience_level_name
FROM job j
JOIN CompanyDetails cd ON j.company_id = cd.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
JOIN Location l ON j.location_id = l.location_id
JOIN WorkType wt ON j.work_type_id = wt.work_type_id
JOIN ExperienceLevel el ON j.experience_level_id = el.experience_level_id;

-- Appendix: Database

CREATE DATABASE Company;

USE Company;

 CREATE TABLE CompanyDetails (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(255),
    industry VARCHAR(30), 
    description VARCHAR(1500)
);

CREATE TABLE SalaryRange (
    salary_id INT PRIMARY KEY,
    min_salary DECIMAL(10, 2),
    max_salary DECIMAL(10, 2)
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(255)
);

CREATE TABLE WorkType (
    work_type_id INT PRIMARY KEY,
    work_type_name VARCHAR(255)
);

CREATE TABLE ExperienceLevel (
    experience_level_id INT PRIMARY KEY,
    experience_level_name VARCHAR(255)
);

CREATE TABLE job (
    job_id INT PRIMARY KEY,
    company_id INT,
    title VARCHAR(255),
    description TEXT,
    salary_id INT,
    location_id INT,
    work_type_id INT,
    experience_level_id INT,
    FOREIGN KEY (company_id) REFERENCES CompanyDetails(company_id),
    FOREIGN KEY (salary_id) REFERENCES SalaryRange(salary_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id),
    FOREIGN KEY (work_type_id) REFERENCES WorkType(work_type_id),
    FOREIGN KEY (experience_level_id) REFERENCES ExperienceLevel(experience_level_id)
);

-- Few of the queries are simple but demonstrated for the sake of answering crucial business queries

-- Count of job postings for each type of work:
SELECT wt.work_type_name, COUNT(*) AS job_count
FROM Job j
JOIN WorkType wt ON j.work_type_id = wt.work_type_id
GROUP BY wt.work_type_name;

-- Top 5 highest-paying jobs:
SELECT j.title, c.company_name, sr.max_salary
FROM Job j
JOIN CompanyDetails c ON j.company_id = c.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
ORDER BY sr.max_salary DESC
LIMIT 5;

-- Top Companies with the most job openings:
SELECT c.company_name, COUNT(*) AS job_openings
FROM Job j
JOIN CompanyDetails c ON j.company_id = c.company_id
GROUP BY c.company_name
ORDER BY job_openings DESC;

-- Calculate the average salary range for jobs in work types within a specific industry (Finance)
SELECT cd.industry, wt.work_type_name, 
AVG(sr.min_salary) AS avg_min_salary, 
AVG(sr.max_salary) AS avg_max_salary
FROM CompanyDetails cd
JOIN job j ON cd.company_id = j.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
JOIN WorkType wt ON j.work_type_id = wt.work_type_id
WHERE cd.industry = 'Finance'
GROUP BY cd.industry, wt.work_type_name;

-- Job titles and companies with the highest average max salary in each city:
SELECT l.location_name, c.company_name, j.title, 
AVG(sr.max_salary) AS average_max_salary
FROM Job j
JOIN CompanyDetails c ON j.company_id = c.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
JOIN Location l ON j.location_id = l.location_id
GROUP BY l.location_name, c.company_name, j.title
ORDER BY average_max_salary, location_name ASC;

-- Find the companies that offer job openings in all available work types
WITH WorkTypes AS (
    SELECT DISTINCT work_type_id
    FROM WorkType
)
SELECT c.company_name
FROM CompanyDetails c
WHERE NOT EXISTS (
    SELECT wt.work_type_id
    FROM WorkTypes wt
    WHERE NOT EXISTS (
        SELECT 1
        FROM job j
        WHERE j.company_id = c.company_id AND j.work_type_id = wt.work_type_id
    )
);

-- Average salary range for companies with more than 4 job postings:
SELECT c.company_name, AVG(sr.min_salary) AS average_min_salary, 
AVG(sr.max_salary) AS average_max_salary
FROM Job j4
JOIN CompanyDetails c ON j.company_id = c.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
GROUP BY c.company_name
HAVING COUNT(j.job_id) > 4;

-- Which top 3 companies have the highest retention rate for employees, inferred from the number of long-term job postings
SELECT 
  c.company_name,
  COUNT(*) AS long_term_postings,
  RANK() OVER (ORDER BY COUNT(*) DESC ) AS ranked
FROM Job j
INNER JOIN CompanyDetails c ON j.company_id = c.company_id
GROUP BY c.company_name
HAVING long_term_postings > 0
ORDER BY long_term_postings DESC
LIMIT 3;

-- Ratio of job postings to the number of companies in each industry (job density), and which industry has the highest job density
SELECT 
  c.industry,
  COUNT(j.job_id) AS postings_count,
  (SELECT COUNT(DISTINCT company_id) FROM CompanyDetails 
  WHERE industry = c.industry) AS companies_count,
  COUNT(j.job_id) / (SELECT COUNT(DISTINCT company_id) FROM CompanyDetails 
  WHERE industry = c.industry) AS job_density
FROM Job j
JOIN CompanyDetails c ON j.company_id = c.company_id
GROUP BY c.industry
ORDER BY job_density DESC;

--  Job titles and their respective companies for jobs with salaries above the average salary for their respective industries
WITH AvgIndustrySalaries AS (
    SELECT cd.industry, AVG(sr.max_salary) AS avg_max_salary
    FROM CompanyDetails cd
    JOIN job j ON cd.company_id = j.company_id
    JOIN SalaryRange sr ON j.salary_id = sr.salary_id
    GROUP BY cd.industry
)
SELECT j.title, cd.company_name
FROM job j
JOIN CompanyDetails cd ON j.company_id = cd.company_id
JOIN SalaryRange sr ON j.salary_id = sr.salary_id
JOIN AvgIndustrySalaries ais ON cd.industry = ais.industry
WHERE sr.max_salary > ais.avg_max_salary
ORDER BY company_name;


--
--

