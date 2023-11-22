
--1. What is the average age of players in the dataset?
SELECT AVG(Age) as avg_age
FROM fifa_data fd 

--2. Which nationality is most prevalent among the players? top 30 country.
SELECT
	Nationality ,
	COUNT(ID) as "Total_Count"
FROM fifa_data fd 
group by Nationality 
ORDER BY "Total_Count" DESC 
LIMIT 30


--3. Is there a correlation between a player's age and their overall rating?
--table of query data
SELECT
	Name ,
	Age ,
	Overall 
FROM fifa_data fd 
order by Overall DESC ,Age DESC 
--correlation calculation manually
SELECT
    (COUNT(*) * SUM(Age * Overall) - SUM(Age) * SUM(Overall)) /
    (SQRT((COUNT(*) * SUM(Age * Age) - SUM(Age) * SUM(Age)) *
    (COUNT(*) * SUM(Overall * Overall) - SUM(Overall) * SUM(Overall)))) AS correlation_coefficient
FROM fifa_data;

--4. What is the distribution of overall ratings among the players?
SELECT 
	name,
	Overall 
FROM fifa_data fd 


--5. Which club and country has the highest average player rating ?
--for country minimum 250 player played
SELECT
	Nationality,
	COUNT(ID) as player_count,
	AVG(Overall) as overall_rating
FROM fifa_data fd 
group by Nationality 
HAVING player_count > 250
ORDER BY  overall_rating DESC , player_count DESC 
--for club lavel
SELECT
	Club ,
	AVG(Overall) as overall_rating
FROM fifa_data fd 
group by Club  
ORDER BY overall_rating DESC

--6. What is the relationship between a player's potential and their age?
SELECT
    (COUNT(*) * SUM(Age * Potential) - SUM(Age) * SUM(Potential)) /
    (SQRT((COUNT(*) * SUM(Age * Age) - SUM(Age) * SUM(Age)) *
    (COUNT(*) * SUM(Potential  * Potential) - SUM(Potential) * SUM(Potential)))) AS correlation_coefficient
FROM fifa_data;


--7. Are there specific positions that tend to have higher overall ratings?
SELECT 
	CASE 
		when "Position" = '' THEN 'Not Specified'
		ELSE "Position"
	END as "Position",
	AVG(Overall) as avg_rating 
FROM fifa_data fd 
WHERE "Position" IS NOT NULL AND "Position" <> ''
group by "Position"
ORDER BY avg_rating DESC 


--9. How does a player's preferred foot influence their performance?
SELECT 
	CASE 
		WHEN "Preferred Foot" = '' THEN 'Not Specified'
		ELSE "Preferred Foot" 
	END AS Preferred_Foot,
	AVG(Overall) as avg_overall_rating,
	AVG(Potential) as avg_potential_rating 
FROM fifa_data 
WHERE "Preferred Foot" IS NOT NULL AND "Preferred Foot" <> ''
GROUP BY Preferred_Foot 
ORDER BY avg_overall_rating DESC, avg_potential_rating DESC 

--10. How do physical attributes like height and weight vary among players?
SELECT
	Name ,
	Height,
	Weight 
FROM fifa_data fd 
order by Height DESC , Weight DESC 

--11. What is the distribution of skill moves ratings among players?
SELECT 
	Name ,
	"Skill Moves" 
from fifa_data fd 
WHERE "Skill Moves" <> ''
order by "Skill Moves" DESC


--12. How does a player's work rate affect their overall rating?
SELECT 
	"Work Rate" ,
	AVG(Overall) as avg_overall_rating 
FROM  fifa_data fd 
WHERE "Work Rate" <> ''
group by "Work Rate" 
ORDER BY avg_overall_rating DESC 


--13. What is the average stamina rating of players in different positions?
SELECT 
	"Position" ,
	AVG(Stamina) as avg_stamina 
FROM fifa_data fd 
WHERE "Position" <> ''
group by "Position" 
order by avg_stamina desc


--14. How do specific skills such as crossing and finishing correlate with each other?
SELECT
    (COUNT(*) * SUM(Crossing  * Finishing) - SUM(Crossing) * SUM(Finishing)) /
    (SQRT((COUNT(*) * SUM(Crossing  * Crossing) - SUM(Crossing) * SUM(Crossing)) *
    (COUNT(*) * SUM(Finishing  * Finishing) - SUM(Finishing) * SUM(Finishing)))) AS correlation_coefficient
FROM fifa_data;


--15. Is there a correlation between a player's strength and their aggression rating?
SELECT
    (COUNT(*) * SUM(Strength  * Aggression) - SUM(Strength) * SUM(Aggression)) /
    (SQRT((COUNT(*) * SUM(Strength  * Strength) - SUM(Strength) * SUM(Strength)) *
    (COUNT(*) * SUM(Aggression  * Aggression) - SUM(Aggression) * SUM(Aggression)))) AS correlation_coefficient
FROM fifa_data;



-- best 24 mens for 4-3-3 formation  team according to their ability, Over all rating and potentiality
SELECT *
FROM (
--for center forward
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('CF','ST') AND 
    	  	Finishing >= 90 AND 
    	  	ShotPower >= 85 AND 
    	  	SprintSpeed >= 80
 LIMIT 3  	  	
) AS subquery1

UNION ALL

SELECT *
FROM (
-- for winger
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('RW','LW','RF','LF') AND 
    Dribbling >= 80 AND 
    Crossing >= 80 AND 
    'Accelaraton' >= 85
LIMIT 5 
) AS subquery2
UNION ALL

SELECT *
FROM (
--defensive midfilder 
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('CDM') 
	LIMIT 2
) AS subquery3

UNION ALL

SELECT *
FROM (
-- midfilder 
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('RAM','RCM','RM','LM','LCM') 
	LIMIT 4
) AS subquery4

UNION ALL

SELECT *
FROM (
--for left  
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('LB','LWB') 
	LIMIT 2
) AS subquery5

UNION ALL

SELECT *
FROM (
--for right back 
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('RB','RWB') 
	LIMIT 2
) AS subquery6

UNION ALL

SELECT *
FROM (
--for centerback back 
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('CB','LCB','RCB') 
	LIMIT 4
) AS subquery7

UNION ALL

SELECT *
FROM (
--for goalkeeper 
    SELECT *
    FROM fifa_data
    WHERE "Position" in ('GK') 
	LIMIT 2
) AS subquery8;
