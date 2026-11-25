DROP TABLE IF EXISTS fact_medal_olympics CASCADE;
DROP TABLE IF EXISTS dim_country CASCADE;
DROP TABLE IF EXISTS dim_athlete CASCADE;
DROP TABLE IF EXISTS dim_olympics CASCADE;
DROP TYPE IF EXISTS medal_enum CASCADE;

create type medal_enum AS ENUM ('Gold', 'Silver', 'Bronze', '');

create table dim_country (
	id_co bigint primary key, 
	noc char(3) NOT NULL,
	country varchar(100),
	continent varchar(20)
);
create table dim_athlete (
	id_ath bigint primary key, 
	"name" varchar(100) NOT NULL,
	sex char(1) 
);
create table dim_olympics (
	id_saol bigint primary key, 
	sport varchar(100) NOT NULL,
	"event" varchar(100) NOT NULL
);
create table fact_medal_olympics(
	id bigint primary key,
	id_co bigint references dim_country(id_co),
	id_ath bigint references dim_athlete(id_ath),
	id_saol bigint references dim_olympics(id_saol),
 	age smallint,
	height smallint,
	weight smallint,
	"year"   smallint NOT NULL,
	medal medal_enum
	);
	