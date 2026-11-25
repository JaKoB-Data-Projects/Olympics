TRUNCATE TABLE fact_medal_olympics, dim_country, dim_athlete, dim_olympics CASCADE;

COPY dim_country (noc, country, id_co, continent)
FROM 'C:/Users/User/Desktop/DSI/Fallstudie/dim_country.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY dim_athlete ("name", sex, id_ath)
FROM 'C:/Users/User/Desktop/DSI/Fallstudie/dim_athlete.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY dim_olympics (sport, "event", id_saol)
FROM 'C:/Users/User/Desktop/DSI/Fallstudie/dim_olympics.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY fact_medal_olympics ( age, height, weight, "year", medal, id_co, id_ath, id_saol,id)
FROM 'C:/Users/User/Desktop/DSI/Fallstudie/fact_medal_olympics.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ';');
