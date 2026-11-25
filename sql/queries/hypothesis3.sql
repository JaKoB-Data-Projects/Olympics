/*WITH cte as (Select id_ath as athlete,
		id_saol,
		medal as first_medal,
		"year",
		LEAD(medal) OVER (Partition BY id_ath, id_saol order by year) as second_medal
FROM fact_medal_olympics)

SELECT 
	   first_medal,
	   second_medal,
	   count(*) As Anzahl
FROM cte
WHERE first_medal in ('Silver', 'Bronze') AND second_medal = 'Gold'
GROUP BY first_medal, second_medal
;*/

Select  '4 years' AS gap,
		f1.medal as current_medal,
		f2.medal as next_medal,
		count(*) AS ANZAHL
		
		
FROM fact_medal_olympics f1
inner JOIN fact_medal_olympics f2 ON f1.year+4 = f2.year
WHERE f1.medal in ('Silver', 'Bronze') and f2.medal = ('Gold') AND f1.id_ath=f2.id_ath AND f1.id_saol=f2.id_saol
group by f1.medal,f2.medal

UNION ALL

Select  '8 years' AS gap,
		f1.medal as current_medal,
		f2.medal as next_medal,
		count(*) AS ANZAHL
		
FROM fact_medal_olympics f1
inner JOIN fact_medal_olympics f2 ON f1.year+8 = f2.year
WHERE f1.medal in ('Silver', 'Bronze') and f2.medal = ('Gold') AND f1.id_ath=f2.id_ath AND f1.id_saol=f2.id_saol
group by f1.medal,f2.medal

UNION ALL

Select  '12 years' AS gap,
		f1.medal as current_medal,
		f2.medal as next_medal,
		count(*) AS ANZAHL
		
		
FROM fact_medal_olympics f1
inner JOIN fact_medal_olympics f2 ON f1.year+12 = f2.year
WHERE f1.medal in ('Silver', 'Bronze') and f2.medal = ('Gold') AND f1.id_ath=f2.id_ath AND f1.id_saol=f2.id_saol
group by f1.medal,f2.medal

UNION ALL

Select  '16 years' AS gap,
		f1.medal as current_medal,
		f2.medal as next_medal,
		count(*) AS ANZAHL
		
		
FROM fact_medal_olympics f1
inner JOIN fact_medal_olympics f2 ON f1.year+16 = f2.year
WHERE f1.medal in ('Silver', 'Bronze') and f2.medal = ('Gold') AND f1.id_ath=f2.id_ath AND f1.id_saol=f2.id_saol
group by f1.medal,f2.medal
