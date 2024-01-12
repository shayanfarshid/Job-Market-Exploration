Decoding the Job Market: An In-depth Exploration

This project aims to analyze and understand the dynamics of the job market using MySQL. It focuses on dissecting various aspects such as job types, salary ranges, and company profiles. The dataset is organized into multiple tables, each representing a different dimension of the job market.

The project uses advanced SQL querying techniques like joins, aggregate functions, and window functions to answer specific questions about the job market. These questions aim to uncover patterns and trends that can provide valuable insights into the current state and future directions of employment opportunities. Visualizations have also been accompanied by the findings via SQL queries to answer business questions.

List of Business Questions and Visualizations Associated:
1. Count the number of job postings for each type of work. 
2. Identify the top 5 highest-paying jobs.
3. Determine the top companies with the most job openings.
4. Calculate the average salary range for jobs in work types within the Finance industry.
5. Find job titles and companies with the highest average max salary in each city.
6. Identify the companies offering job openings in all available work types.
7. Determine the average salary range for companies with more than 4 job postings.
8. Find the top 3 companies with the highest retention rate for employees based on long-term job postings.
9. Calculate the ratio of job postings to the number of companies in each industry (job density) and determine the industry with the highest job density.
10. Identify job titles and their respective companies for jobs with salaries above the average salary for their respective industries. 

This comprehensive analysis offers a multi-dimensional view of the job market, highlighting crucial trends and patterns that are essential for understanding current employment scenarios. This project not only aids job seekers and employers but also provides valuable insights for policy-makers and economists.

**Conversion of Dataset into Tables**

Understanding the Dataset:
The first step was to examine the job_postings.csv dataset thoroughly. This involved identifying the key columns and understanding the type of data each column represents. Essential fields like job_id, company_id, title, description, salary range, and location were noted, as these form the core of our database structure.

Database Schema Design:
Based on the dataset analysis, I designed a relational database schema to efficiently store and manage the data. The schema comprised several tables - Job, Company, SalaryRange, Location, WorkType, and ExperienceLevel - reflecting the entities identified in the dataset.

Data Type Selection:
For each column in these tables, I selected appropriate SQL data types. For instance, numerical identifiers like job_id and company_id were assigned the INT type, textual information such as title and description were assigned VARCHAR or TEXT, and salary fields were set as DECIMAL to accommodate financial data.

Normalization and Integrity:
To ensure data integrity and reduce redundancy, normalization principles were applied. This included dividing the data into logical tables and defining primary keys (such as job_id for the Job table) and foreign keys (like company_id in the Job table referencing the Company table).

Data Import Process:
The actual conversion involved importing data from the CSV file into the MySQL database. Tools and functions within MySQL were utilized to map each column in the CSV file to its corresponding column in the database tables. Special attention was paid to handling null values and ensuring that data formats in the CSV file matched the defined data types in the SQL tables.

Creating Relationships:
Finally, relationships between tables were established as per the ER Diagram. This included defining one-to-many and many-to-one relationships between Jobs and other entities like Companies, SalaryRange, etc., ensuring a relational structure among these entities.
