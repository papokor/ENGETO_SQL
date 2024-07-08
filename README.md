# ENGETO_SQL
<strong>Pokorný Pavel - kurz Datová Akademie 16. 1. 2024 - 2. 4. 2024</strong>
<strong>Projekt SQL pro kurz Engeto - Ceny potravin</strong>
------------------------------------------
Příprava dat, výstupů a odpovědí na předem definované otázky, které mapují dostupnost dostupnost základních potravin široké veřejnosti a porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

<strong>Otázky definované kolegy pro tiskové oddělení:</strong>

<ol>
<li>Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?</li>

<li>Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?</li>

<li>Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?</li>

<li>Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?</li>

<li>Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?</li>
</ol>

<strong>Podklady:</strong>
<li>czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období </li>
<li>czechia_price – Informace o cenách vybraných potravin za několikaleté období</li>
<li>+ příslušné číselníky a dodatečné tabulky (HDP, GINI, populace)</li>



Poznámka:
Tabulka o cenách obsahuje hodnoty za kratší časový úsek, porovnání bude prováděno na tomto období (2006 - 2018).

-------------------------------------------------------------

<b>Otázka 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?</b>

Z dostupných dat je patrné, že mzdy v meziročním srovnání mezi roky 2018 a 2006 rostly ve všech odvětvích. Největší nárůst byl v odvětví Zdravotní a sociální péče (76,94 %), nejnižší naopak v odvětví Peněžnictví a pojišťovnictví (36,33 %). 

V průběhu jednotlivých let však růst nebyl pravidlem, v některých letech (a odvětvích) docházelo i k poklesu mezd. Pro nejvíce odvětví došlo k poklesu v roce 2013 (došlo k poklesu mezd u 11 odvětví).  

<b>Otázka 2 - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?</b>

V roce 2006, kdy byla průměrná mzda ve výši 20 753 Kč a průměrná cena Chléb konzumní kmínový 16,12 Kč, bylo možné v tomto roce zakoupit 1287,455 Kg tohoto produktu. P roce 2018, při průměrné mzdě 32 535,86 a průměrné ceně kmínového chleba 24,24 Kč, bylo možné za průměrnou mzdu zakoupit 1342,238 kg tohoto pečiva. 

Pro produkt dojnic pak obdobně - v roce 2006 lze s průměrnou cenou 14,44 Kč za litr zakoupit 1437,242 litru tohoto bílého produktu, v roce 2018, kdy se průměrná cena litru vyhoupla na 19,82 Kč lze pak vypít i 1641,567 plnotučného pasterovaného mléka. 

<b>Otázka 3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?</b>

Nejpomalejší průměrný meziroční nárůst měl ve sledovaném období cukr krystal (průměrně -1,92), nejnižší meziroční nárůst (pokles) v jednom roce pak rajská jablka (rok 2007 -30,28 %).

<b>Otázka 4 - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?</b>

Z porovnání průměrných meziročních nárůstů cen vyplývá, že nejvyšší rozdíl v těchto ukazatelích je v roce 2013 a to 6,79 p.b. 

<b>Otázka 5 - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?</b>

Z dostupných dat se dá pozorovat uričtá závislost v pohybu úrovně HDP a sledovaných ukazatelů, více možná ve vývoji cen potravin. Avšak vliv není zcela jednoznačný a proto na položenou otázku nelze s jistotou odpovědět. 

