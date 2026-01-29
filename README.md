# Introduction
📊 In this project we are diving into the data job market. Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

### SQL queries - Check them out here: [project_sql folder](/project_sql/)

# Background
This project was created to better understand the Data Analyst job market by identifying the highest-paying and most in-demand skills, helping others efficiently find the best job opportunities.

Data hails from my [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
In exploring the Data Analyst job market, I leveraged several essential tools:

- **SQL:** The core of my analysis, enabling me to query the database and uncover key insights.
- **PostgreSQL:** The selected database management system, well-suited for managing and analyzing job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Crucial for version control and sharing SQL scripts, enabling collaboration and effective project tracking.

# The Analysis

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT 
    job_id
	, job_title
	, job_location
	, job_schedule_type
	, salary_year_avg
	, job_posted_date
    , name AS company_name
FROM job_postings_fact AS jpf
LEFT JOIN 
    company_dim cd ON jpf.company_id = cd.company_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
ORDER BY salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** The top-paying roles range from $184,000 to $650,000, highlighting the field’s substantial earning potential.
- **Diverse Employers:** High salaries are offered by companies such as Mantys, SmartAsset, Meta, and AT&T, showing demand across multiple industries.
- **Job Title Variety:** Positions range from Data Analyst to Director of Analytics, reflecting the diversity of roles and specializations within the field.

![Top Paying Roles](/assets/Code_Generated_Image.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To identify the skills demanded by top-paying roles, I combined job postings with skills data, revealing what employers prioritize for high-compensation positions.
```sql
WITH top_jobs AS (
    SELECT 
        job_id
        , job_title
        , job_location
        , salary_year_avg
        , name AS company_name
    FROM job_postings_fact AS jpf
    LEFT JOIN 
        company_dim cd ON jpf.company_id = cd.company_id
    WHERE 
        salary_year_avg IS NOT NULL 
        AND job_title_short = 'Data Analyst' 
        AND job_location = 'Anywhere' 
    ORDER BY 
        salary_year_avg DESC
) 
SELECT 
    tj.*
    , skills
FROM top_jobs tj
INNER JOIN 
    skills_job_dim sjd ON tj.job_id = sjd.job_id
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
Most In-Demand Skills for Top-Paying Data Analyst Jobs in 2023:

1. SQL tops the list, appearing in 8 of the top 10 roles.
2. Python is a close second, featured in 7 positions.
3. Tableau is also highly sought after, appearing 6 times.

Other valuable skills such as R, Snowflake, Pandas, and Excel are in demand to varying degrees.

![Top Paying Skills](/assets/2_top_paying_roles_skills.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. In-Demand Skills for Data Analysts

This query highlighted the skills most frequently sought in job postings, pinpointing areas of high demand for on-site Data Analysts.

```sql
SELECT 
    skills
    , COUNT(sjd.skill_id) AS demand_count
FROM job_postings_fact jpf
INNER JOIN 
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = FALSE 
GROUP BY 
    sd.skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL and Excel** continue to be foundational, highlighting the importance of strong data processing and spreadsheet skills.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, reflecting the growing demand for technical expertise in data storytelling and decision-making support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 85337        |
| Excel    | 62420        |
| Python   | 52996        |
| Tableau  | 42809        |
| Power BI | 36859        |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills
    , ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN 
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 20;

```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **Big Data & Machine Learning Skills:** Highest salaries are linked to expertise in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), highlighting the value of advanced data processing and predictive modeling.
- **Software Development & Deployment Proficiency:** Proficiency in tools like GitLab, Kubernetes, and Airflow shows a premium for analysts who can manage automation and data pipelines, bridging the gap between analysis and engineering.
- **Cloud Computing Expertise:** Skills in cloud and data platforms (Elasticsearch, Databricks, GCP) emphasize the growing importance of cloud-based analytics, indicating that cloud expertise enhances earning potential.

![Top Paying Skills](/assets/Code_Generated_Image%20(2).png)
*Bar graph visualizing the top 10 highest-paying skills for data analysts.*

### 5. Most Optimal Skills to Learn

By combining demand and salary data, this query identified skills that are both highly sought after and well-compensated, providing a strategic focus for skill development.

```sql
SELECT 
    sd.skill_id
    , sd.skills
    , COUNT(sjd.job_id) AS demand_count
    , ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN 
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.job_id) > 10
ORDER BY
    demand_count DESC, 
    avg_salary DESC
LIMIT 10;
```
| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|------------------:|
| 0        | sql        | 398          | 97,237           |
| 181      | excel      | 256          | 87,288           |
| 1        | python     | 236          | 101,397          |
| 182      | tableau    | 230          | 99,288           |
| 5        | r          | 148          | 100,499          |
| 183      | power bi   | 110          | 97,431           |
| 7        | sas        | 63           | 98,902           |
| 186      | sas        | 63           | 98,902           |
| 196      | powerpoint | 58           | 88,701           |
| 185      | looker     | 49           | 103,795          |


*Table of the most optimal skills for data analyst sorted by demand count*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **Core Data Skills:** PSQL and Excel remain foundational, with demand counts of 398 and 256 respectively. While their average salaries are slightly lower ($97,237 for SQL and $87,288 for Excel), these skills are essential for data processing, manipulation, and reporting.
- **High-Demand Programming & Analysis Tools:** Python and R show strong demand (236 and 148), with average salaries around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued across the industry.
- **Data Visualization & Business Intelligence Tools:** Tableau and Power BI are important for presenting insights, with demand counts of 230 and 110 and average salaries of $99,288 and $97,431, highlighting the need for effective data storytelling.
- **Advanced Analytics & BI Platforms:** Looker, though less in demand (49), offers a high average salary ($103,795), suggesting that expertise in specialized BI tools can be particularly rewarding for analysts.


# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: On-site data analyst roles with the highest salaries show a wide range of compensation, with top earnings reaching $650,000
2. **Skills for Top-Paying Jobs**: Advanced SQL proficiency is crucial for securing high-paying data analyst positions, emphasizing its importance for top salaries.
3. **Most In-Demand Skills**: SQL is also the most sought-after skill in the data analyst job market, making it essential for anyone entering the field.
4. **Big Data & Machine Learning Skills**: The highest salaries are associated with expertise in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), underscoring the value of advanced data processing and predictive modeling.
5. **Optimal Skills for Job Market Value**: With both high demand and strong salary potential, SQL stands out as one of the most strategic skills for data analysts to master in order to maximize their market value.

### Closing Thoughts
This project strengthened my SQL skills while offering valuable insights into the data analyst job market. The findings provide guidance on prioritizing skill development and job search strategies. By focusing on high-demand, well-compensated skills, aspiring data analysts can better position themselves in a competitive market. Overall, this exploration emphasizes the importance of continuous learning and staying current with emerging trends in data analytics.