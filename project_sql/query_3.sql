/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for on-site job seekers.
*/

SELECT 
    skills
    , COUNT(sjd.skill_id) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = FALSE 
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 5

/*
**Conclusion**

The results show that **SQL is the most in-demand skill** for Data Analysts, followed by **Excel and Python**. 
Visualization tools such as **Tableau and Power BI** are also highly requested by employers. 
Overall, this indicates that **strong data querying, analysis, and visualization skills are essential** for Data Analysts seeking on-site job opportunities.


[
  {
    "skills": "sql",
    "demand_count": "85337"
  },
  {
    "skills": "excel",
    "demand_count": "62420"
  },
  {
    "skills": "python",
    "demand_count": "52996"
  },
  {
    "skills": "tableau",
    "demand_count": "42809"
  },
  {
    "skills": "power bi",
    "demand_count": "36859"
  }
]
*/
