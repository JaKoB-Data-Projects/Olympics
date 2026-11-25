WITH physis AS (
SELECT "year",
	   sex,
	   (f.weight/10.0) AS weight,
	   (f.height/10.0) AS height,
	   (f.weight/10.0) /(f.height/1000.0)^2 AS BMI,
	   (f.weight/10.0) /(f.height/1000.0)^3 AS Ponderal_Index
From fact_medal_olympics f
LEFT JOIN dim_athlete a on f.id_ath = a.id_ath
Where f.medal in ('Gold','Silver', 'Bronze')
AND f.height is NOT NULL
AND f.weight is NOT NULL)




Select "year" as olympics,
		sex,
		ROUND(AVG(weight)::numeric,2) AS avg_weight,
		ROUND(AVG(height)::numeric,2) AS avg_height,
		ROUND(AVG(BMI)::numeric,2) AS avg_bmi,
		ROund(AVG(Ponderal_Index)::numeric,2) AS avg_ponderal_index
		
FROM physis
group by "year", sex
order by "year" ASC, sex