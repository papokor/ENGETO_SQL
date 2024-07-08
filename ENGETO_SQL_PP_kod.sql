

/* ZDROJOVE_TABULKY */

SELECT * 
FROM czechia_payroll;

SELECT * 
FROM czechia_price;

SELECT * 
FROM czechia_price_category; 

SELECT * 
FROM czechia_payroll_value_type;
/* code: 5958 - Průměrná hrubá mzda na zaměstnance */

SELECT * 
FROM czechia_payroll_calculation; 

SELECT * 
FROM czechia_payroll_unit; 

SELECT * 
FROM czechia_payroll_industry_branch;


/* -------------------------------------------------------------------------------------------------- */



SELECT * FROM czechia_payroll 
ORDER BY payroll_year DESC; 

SELECT * FROM czechia_payroll 
ORDER BY payroll_year ASC; 


SELECT * FROM czechia_price
ORDER BY date_from DESC; 

SELECT * FROM czechia_price
ORDER BY date_from ASC; 


/* Porovnatelné období pouze společné roky 2006 - 2018 (tabulka price omezenější data, v tab. payroll data za 2000 - 2021) */


SELECT *
FROM czechia_price cpr
JOIN czechia_payroll cpa 
ON year(cpr.date_from) = cpa.payroll_year;



SELECT 
cpc.name AS food_category, 
cpr.value AS price, 
cpr.date_from, 
cpr.date_to, 
cpa.value AS average_wages, 
cpib.name AS industry, 
cpa.payroll_year 
FROM czechia_price cpr
JOIN czechia_payroll cpa 
	ON year(cpr.date_from) = cpa.payroll_year
	AND cpa.value_type_code = 5958
	AND cpr.region_code IS null
JOIN czechia_price_category cpc 
ON cpr.category_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
ON cpa.industry_branch_code = cpib.code;

/* ---- */

CREATE OR REPLACE TABLE t_pavel_pokorny_project_SQL_primary_final AS
SELECT 
cpc.name AS food_category, 
cpr.value AS price, 
cpr.date_from, 
cpr.date_to, 
cpa.value AS average_wages, 
cpib.name AS industry, 
cpa.payroll_year 
FROM czechia_price cpr
JOIN czechia_payroll cpa 
	ON year(cpr.date_from) = cpa.payroll_year
	AND cpa.value_type_code = 5958
	AND cpr.region_code IS null
JOIN czechia_price_category cpc 
ON cpr.category_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
ON cpa.industry_branch_code = cpib.code;

SELECT * 
FROM t_pavel_pokorny_project_SQL_primary_final
ORDER BY 
date_from, 
food_category, 
industry;


/* --------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------- */

/* TABULKY */

SELECT * 
FROM countries;

SELECT * 
FROM economies;


/* ---------------------------------- */

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



/* --------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------- */





/* Otázka 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? -------------------------------------------------------------------*/

SELECT 
industry, 
payroll_year, 
round(avg(average_wages), 2) AS average_wages_per_year
FROM t_pavel_pokorny_project_SQL_primary_final
GROUP BY 
industry, 
payroll_year
ORDER BY 
industry, 
average_wages_per_year; 

/* Pouze první a poslední rok k porovnání*/

SELECT DISTINCT 
industry, 
payroll_year,
round(avg(average_wages), 2) AS average_wages_per_year
FROM t_pavel_pokorny_project_SQL_primary_final 
WHERE payroll_year IN (2006, 2018)
GROUP BY 
industry, 
payroll_year; 

CREATE OR REPLACE VIEW v_pavel_pokorny_project_avg_wages_per_year AS 
SELECT 
industry, 
payroll_year, 
round(avg(average_wages), 2) AS average_wages_per_year
FROM t_pavel_pokorny_project_SQL_primary_final 
GROUP BY 
industry, 
payroll_year
ORDER BY 
industry, 
average_wages_per_year;

SELECT * 
FROM v_pavel_pokorny_project_avg_wages_per_year; 

CREATE OR REPLACE VIEW v_pavel_pokorny_project_avg_wages_growth AS 
SELECT DISTINCT 
vw.industry, 
vw.payroll_year, 
vw2.payroll_year + 1 AS next_year,
	round( ( vw.average_wages_per_year  - vw2.average_wages_per_year ) / vw2.average_wages_per_year  * 100, 2 ) as avg_wages_growth
FROM v_pavel_pokorny_project_avg_wages_per_year vw
JOIN v_pavel_pokorny_project_avg_wages_per_year vw2
	ON vw.industry = vw2.industry 
	AND vw.payroll_year = vw2.payroll_year + 1
ORDER BY 
industry, 
payroll_year; 

SELECT * 
FROM v_pavel_pokorny_project_avg_wages_growth; 


/* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */






/* Otázka 2 -  Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */

SELECT * 
FROM czechia_price_category; 

SELECT 
*, 
round(average_wages/price) AS units
FROM t_pavel_pokorny_project_SQL_primary_final 
WHERE food_category = 'Chléb konzumní kmínový'
AND payroll_year IN (2006, 2018);

SELECT 
*, 
round(average_wages/price) AS units
FROM t_pavel_pokorny_project_SQL_primary_final 
WHERE food_category = 'Mléko polotučné pasterované'
AND payroll_year IN (2006, 2018);


SELECT 
food_category, 
payroll_year,
	round(avg(price), 2) AS average_price,
	round(avg(average_wages), 2) AS average_wages_for_all_ind,
	round(avg(average_wages)/avg(price), 2) AS average_available_units_per_wages
FROM t_pavel_pokorny_project_SQL_primary_final 
WHERE food_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
AND payroll_year IN (2006, 2018)
GROUP BY 
food_category, 
payroll_year;




/* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */






/* Otázka 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? */


CREATE OR REPLACE VIEW v_pavel_pokorny_project_avg_prices_per_year AS 
	SELECT DISTINCT 
	food_category, 
	year(date_from) AS year, 
	round(avg(price), 2) AS avg_price
	FROM t_pavel_pokorny_project_SQL_primary_final 
	GROUP BY 
food_category, 
year(date_from);

SELECT *
FROM v_pavel_pokorny_project_avg_prices_per_year; 


CREATE OR REPLACE VIEW v_pavel_pokorny_project_avg_price_growth AS 
SELECT DISTINCT 
v.food_category, 
v.year, v2.year + 1 AS next_year,
	round( ( v.avg_price  - v2.avg_price  ) / v2.avg_price  * 100, 2 ) as avg_price_growth
FROM v_pavel_pokorny_project_avg_prices_per_year v
JOIN v_pavel_pokorny_project_avg_prices_per_year v2
	ON v.food_category = v2.food_category 
	AND v.year = v2.year + 1
ORDER BY food_category, YEAR; 

SELECT * 
FROM v_pavel_pokorny_project_avg_price_growth 
ORDER BY 
avg_price_growth; 

SELECT 
food_category, 
round(avg(avg_price_growth), 2) AS price_growth_for_period
FROM v_pavel_pokorny_project_avg_price_growth
GROUP BY 
food_category
ORDER BY 
price_growth_for_period; 
	


/* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */






/* Otázka 4 -  Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?  */
	

SELECT * 
FROM v_pavel_pokorny_project_avg_wages_growth;

SELECT * 
FROM v_pavel_pokorny_project_avg_price_growth; 

SELECT
	payroll_year,
	year,
	round(avg(avg_wages_growth), 2) AS avg_wages_growth_per_year,
	round(avg(avg_price_growth), 2) AS avg_price_growth_per_year
FROM v_pavel_pokorny_project_avg_wages_growth vwg
JOIN  v_pavel_pokorny_project_avg_price_growth vpg
	ON vwg.payroll_year = vpg.year
GROUP BY 
year;

SELECT
	year,
	round(avg(avg_wages_growth), 2) AS avg_wages_growth_per_year,
	round(avg(avg_price_growth), 2) AS avg_price_growth_per_year,
	round(avg(avg_price_growth), 2) - round(avg(avg_wages_growth), 2) AS avg_growth_difference
FROM v_pavel_pokorny_project_avg_wages_growth vwg
JOIN  v_pavel_pokorny_project_avg_price_growth vpg
	ON vwg.payroll_year = vpg.year
GROUP BY 
year; 


/* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */






/* Otázka 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem? */

SELECT * 
FROM t_pavel_pokorny_project_SQL_secondary_final; 

SELECT *
FROM t_pavel_pokorny_project_SQL_secondary_final 
WHERE country = 'Czech republic';

CREATE OR REPLACE VIEW v_pavel_pokorny_project_gdp_growth as
SELECT 
t.country, 
t.year, t2.year + 1 AS next_year,
	round( ( t.gdp  - t2.gdp  ) / t2.gdp  * 100, 2 ) as gdp_growth
FROM 
t_pavel_pokorny_project_SQL_secondary_final   t
JOIN t_pavel_pokorny_project_SQL_secondary_final  t2
	ON t.country = t2.country 
	AND t.year = t2.year + 1
WHERE 
t.country = 'Czech Republic'
ORDER BY 
t.`year`;

SELECT * FROM v_pavel_pokorny_project_gdp_growth; 

SELECT
	vpg.year,
	round(avg(avg_wages_growth), 2) AS avg_wages_growth_per_year,
	round(avg(avg_price_growth), 2) AS avg_price_growth_per_year,
	vgg.gdp_growth
FROM 
v_pavel_pokorny_project_avg_wages_growth vwg
JOIN  v_pavel_pokorny_project_avg_price_growth vpg
	ON 
	vwg.payroll_year = vpg.year
JOIN v_pavel_pokorny_project_gdp_growth vgg 
	ON 
	vwg.payroll_year = vgg.year
GROUP BY year; 


