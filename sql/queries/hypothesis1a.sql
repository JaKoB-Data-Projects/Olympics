Select min(year) as first_year_woman,
		o.sport as sport,
		a.sex as sex,
		o.event as olympics
FROM fact_medal_olympics f
LEFT JOIN dim_athlete a on f.id_ath = a.id_ath
LEFT JOIN dim_country c on f.id_co = c.id_co
LEFT JOIN dim_olympics o on f.id_saol = o.id_saol

group by o.event,o.sport,a.sex
order by first_year_woman ASC
