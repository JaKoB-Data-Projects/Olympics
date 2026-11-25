Select min(year) as first_year,
		o.sport as sport,
		c.country as country,
		c.continent as continent,
		o.event as "event"
FROM fact_medal_olympics f
LEFT JOIN dim_athlete a on f.id_ath = a.id_ath
LEFT JOIN dim_country c on f.id_co = c.id_co
LEFT JOIN dim_olympics o on f.id_saol = o.id_saol
WHERE (c.continent = 'africa' or c.continent = 'latin america')
and (o.sport in ('Sailing', 'Fencing',  'Equestrianism', 'Hockey', 'Golf'))
group by c.country,o.event,o.sport,c.continent
order by o.sport, first_year ASC
