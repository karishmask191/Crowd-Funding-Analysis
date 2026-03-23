Create database crowdfunding_kickstarter;
use crowdfunding_starter;
SELECT * FROM projects
LIMIT 10;
SHOW TABLES;

-- 1. Total NO. of Projects
SELECT
concat(round(COUNT(ProjectID)/1000),' K') AS Total_Projects 
From projects;

-- 2. Successful Rate %
SELECT 
CONCAT(ROUND(COUNT(CASE WHEN state='successful' THEN 1 END)
 * 100.0 / COUNT(*),2),'%') AS Success_Rate
FROM projects;

-- 3. Total Amount Raised 
SELECT 
CONCAT(round(SUM(usd_pledged)/1000000000, 2),' B') AS Total_Amnt_Raised
FROM projects;

-- 4. Successful Raised USD
SELECT 
CONCAT(ROUND(SUM(usd_pledged)/1000000000, 2),' B') AS Successful_Amnt_Raised
FROM projects
WHERE state = 'successful';

-- 5. Total Backers
SELECT 
CONCAT(round(SUM(backers_count)/1000000,1),' M') AS Total_Backers
FROM projects;

-- 6. Total Backers (Successful)
SELECT 
CONCAT(round(SUM(backers_count)/1000000,1),' M') AS Successful_Backers
FROM projects
WHERE state='successful';

-- 7. Average Days for Successful Projects
SELECT 
CONCAT(ROUND(AVG(DATEDIFF(
FROM_UNIXTIME(deadline),
FROM_UNIXTIME(created_at)
))),' Days') AS Avg_Succesful_Duration
FROM projects
WHERE state='successful';

-- 8. Total NO. of Projects by Year / Month
SELECT 
YEAR(FROM_UNIXTIME(created_at)) AS Year,
MONTH(FROM_UNIXTIME(created_at)) AS Month,
COUNT(*) AS Total_Projects
FROM projects
GROUP BY Year, Month
ORDER BY Year, Month;

-- 9. Total Projects based on Outcome(state)
SELECT State, COUNT(*) AS Total_projects
FROM projects
GROUP BY state
ORDER BY total_projects DESC;


-- 10. Total Projects by Location
SELECT Country, COUNT(*) AS Total_projects
FROM projects
GROUP BY country
ORDER BY Total_projects DESC;


-- 11. Total Number of Projects By Amount Raised
SELECT 
    name AS Project_name,
    State,
    (goal * static_usd_rate) AS Amount_raised
FROM projects
WHERE state = 'successful'
order by amount_raised desc;

-- 12. Successful Projects By Backers 
SELECT 
    name AS Project_name,
    State,
    Backers_count
FROM projects
WHERE state = 'successful'
ORDER BY backers_count DESC;

-- 13. TOP 5 Successful Projects
SELECT 
name AS Project_Name,
CONCAT(ROUND(backers_count/1000),' K') AS Successful_Backers,
CONCAT(ROUND(usd_pledged/1000000,2),' M') AS Amount_Raised
FROM projects
WHERE state = 'successful'
ORDER BY backers_count DESC, usd_pledged DESC
LIMIT 5;

-- 14. Success Rate% by Goal Range
SELECT 
    CASE 
        WHEN (goal) < 1000 THEN '< 1K'
        WHEN (goal)  < 10000 THEN '1K - 10K'
        WHEN (goal) < 50000 THEN '10K - 50K'
        ELSE '50K+'
    END AS Goal_range,
    COUNT(ProjectID) AS Total_projects,
    COUNT(CASE WHEN state = 'successful' THEN 1 END) AS Successful_projects,
    CONCAT(ROUND(COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(ProjectID),2),'%') AS Success_Rate
FROM projects
GROUP BY goal_range
ORDER BY success_Rate DESC;
