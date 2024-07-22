
SELECT 
	country, 
	`year` , 
	gdp, 
	gini, 
	population 
FROM economies 
WHERE country IN
	(SELECT country 
	FROM countries)
	AND `year` BETWEEN 2006 AND 2018;

/* ---------------------------------- */


CREATE OR REPLACE TABLE t_pavel_pokorny_project_SQL_secondary_final AS
SELECT 
	country, 
	`year` , 
	gdp, 
	gini, 
	population 
FROM economies 
WHERE country IN 
	(SELECT country
	FROM countries)
	AND `year` BETWEEN 2006 AND 2018;

SELECT * 
FROM t_pavel_pokorny_project_SQL_secondary_final;
