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
