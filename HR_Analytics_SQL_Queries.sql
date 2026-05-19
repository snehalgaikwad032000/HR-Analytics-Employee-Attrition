Queries to find out business insights and answer business questions.

QUERY 1 — TOTAL EMPLOYEES
SELECT COUNT(*) AS total_employees
FROM employee_attrition;

QUERY 2 — TOTAL ATTRITION COUNT
SELECT COUNT(*) AS attrition_count
FROM employee_attrition
WHERE attrition = 'Yes';

QUERY 3 — ATTRITION RATE
SELECT
    ROUND(
        (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM employee_attrition;


QUERY 4 — ATTRITION BY DEPARTMENT
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY department
ORDER BY attrition_count DESC;


QUERY 5 — ATTRITION BY GENDER
SELECT
    gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY gender;


QUERY 6 — AVERAGE MONTHLY INCOME BY JOB ROLE
SELECT
    job_role,
    ROUND(AVG(monthly_income), 2) AS avg_salary
FROM employee_attrition
GROUP BY job_role
ORDER BY avg_salary DESC;


QUERY 7 — OVERTIME VS ATTRITION
SELECT
    over_time,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY over_time;


QUERY 8 — JOB SATISFACTION ANALYSIS
SELECT
    job_satisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY job_satisfaction
ORDER BY job_satisfaction;


QUERY 9 — ATTRITION BY AGE
SELECT
    age,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY age
ORDER BY age;


QUERY 10 — TOP 10 HIGHEST PAID EMPLOYEES
SELECT
    employee_id,
    job_role,
    department,
    monthly_income
FROM employee_attrition
ORDER BY monthly_income DESC
LIMIT 10;


11 — WINDOW FUNCTION
Rank Highest Paid Employees Within Each Department
SELECT
    employee_id,
    department,
    job_role,
    monthly_income,
    RANK() OVER(
        PARTITION BY department
        ORDER BY monthly_income DESC
    ) AS salary_rank
FROM employee_attrition;


12 — CTE (COMMON TABLE EXPRESSION)
Find Employees Earning Above Department Average
WITH department_avg_salary AS (
    SELECT
        department,
        AVG(monthly_income) AS avg_salary
    FROM employee_attrition
    GROUP BY department
)

SELECT
    e.employee_id,
    e.department,
    e.monthly_income,
    d.avg_salary
FROM employee_attrition e
JOIN department_avg_salary d
ON e.department = d.department
WHERE e.monthly_income > d.avg_salary;


13 — SUBQUERY
Employees With Maximum Salary
SELECT
    employee_id,
    job_role,
    monthly_income
FROM employee_attrition
WHERE monthly_income = (
    SELECT MAX(monthly_income)
    FROM employee_attrition
);


14 — ADVANCED ATTRITION RISK ANALYSIS
SELECT
    employee_id,
    age,
    monthly_income,
    job_satisfaction,
    work_life_balance,
    over_time,

    CASE
        WHEN over_time = 'Yes'
            AND job_satisfaction <= 2
            AND work_life_balance <= 2
        THEN 'High Risk'

        WHEN job_satisfaction = 3
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS attrition_risk
FROM employee_attrition;


15 — DENSE_RANK()
Top Earners Across Entire Company
SELECT
    employee_id,
    department,
    monthly_income,

    DENSE_RANK() OVER(
        ORDER BY monthly_income DESC
    ) AS company_salary_rank
FROM employee_attrition;


16 — RUNNING TOTAL
Salary Expense Growth
SELECT
    employee_id,
    monthly_income,

    SUM(monthly_income)
    OVER(
        ORDER BY employee_id
    ) AS running_salary_total
FROM employee_attrition;
7 — MULTIPLE CONDITION ANALYSIS
High Attrition Departments
SELECT
    department,

    COUNT(*) AS total_employees,

    SUM(
        CASE
            WHEN attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS attrition_count,

    ROUND(
        SUM(
            CASE
                WHEN attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate

FROM employee_attrition

GROUP BY department

HAVING attrition_rate > 10;
