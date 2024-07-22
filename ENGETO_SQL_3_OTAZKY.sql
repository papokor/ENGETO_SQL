/* OTÁZKY PROJEKTU --------------------------------- */

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
	round( ( vw.average_wages_per_year  - vw2.average_wages_per_year ) / vw2.average_wages_per_year  * 100, 2 ) AS avg_wages_growth
FROM v_pavel_pokorny_project_avg_wages_per_year vw
JOIN v_pavel_pokorny_project_avg_wages_per_year vw2
	ON vw.industry = vw2.industry 
	AND vw.payroll_year = vw2.payroll_year + 1
ORDER BY 
	industry, 
	payroll_year; 

SELECT * 
FROM v_pavel_pokorny_project_avg_wages_growth; 




/* Otázka 2 -  Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */



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
	round( (v.avg_price - v2.avg_price) / v2.avg_price * 100, 2) as avg_price_growth
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
	



/* Otázka 4 -  Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?  */
	


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



/* Otázka 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem? */

SELECT * 
FROM t_pavel_pokorny_project_SQL_secondary_final; 

SELECT *
FROM t_pavel_pokorny_project_SQL_secondary_final 
WHERE country = 'Czech republic';

CREATE OR REPLACE VIEW v_pavel_pokorny_project_gdp_growth AS
SELECT 
	t.country, 
	t.year, t2.year + 1 AS next_year,
	round( ( t.gdp  - t2.gdp ) / t2.gdp * 100, 2 ) AS gdp_growth
FROM 
	t_pavel_pokorny_project_SQL_secondary_final t
JOIN t_pavel_pokorny_project_SQL_secondary_final t2
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
