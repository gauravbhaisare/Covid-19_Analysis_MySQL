# Covid-19_Analysis_MySQL
COVID-19 SQL Analysis Project<br>
Project Overview<br>
This project aims to analyze the COVID-19 pandemic using SQL. The dataset includes various metrics such as case counts, testing data, vaccination progress, and demographic information. The goal is to extract meaningful insights and trends through SQL queries.

Dataset<br>
The dataset contains information from January 1, 2020, to April 7, 2021, and includes the following tables and columns:<br>

covid_deaths<br>
iso_code: Country code<br>
continent: Continent name<br>
location: Country name<br>
date: Date of the record<br>
new_tests: Number of new tests conducted<br>
total_tests: Total number of tests conducted<br>
total_cases: Total number of cases<br>
new_cases: Number of new cases<br>
new_cases_smoothed: Number of new cases (smoothed)<br>
total_deaths: Total number of deaths<br>
new_deaths: Number of new deaths<br>
new_deaths_smoothed: Number of new deaths (smoothed)<br>
total_cases_per_million: Total number of cases per million people<br>
new_cases_per_million: Number of new cases per million people<br>
new_cases_smoothed_per_million: Number of new cases (smoothed) per million people<br>
total_deaths_per_million: Total number of deaths per million people<br>
new_deaths_per_million: Number of new deaths per million people<br>
new_deaths_smoothed_per_million: Number of new deaths (smoothed) per million people<br>
reproduction_rate: Reproduction rate of the virus<br>
icu_patients: Number of ICU patients<br>
icu_patients_per_million: Number of ICU patients per million people<br>
hosp_patients: Number of hospital patients<br>
hosp_patients_per_million: Number of hospital patients per million people<br>
weekly_icu_admissions: Weekly number of ICU admissions<br>
weekly_icu_admissions_per_million: Weekly number of ICU admissions per million people<br>
weekly_hosp_admissions: Weekly number of hospital admissions<br>
weekly_hosp_admissions_per_million: Weekly number of hospital admissions per million people<br><br>
covid_vaccination<br>
iso_code: Country code<br>
location: Country name<br>
date: Date of the record<br>
total_vaccinations: Total number of vaccinations<br>
people_vaccinated: Total number of people vaccinated<br>
people_fully_vaccinated: Total number of people fully vaccinated<br>
daily_vaccinations_raw: Daily number of vaccinations (raw)<br>
daily_vaccinations: Daily number of vaccinations (smoothed)<br>
total_vaccinations_per_hundred: Total number of vaccinations per hundred people<br>
people_vaccinated_per_hundred: Number of people vaccinated per hundred people<br>
people_fully_vaccinated_per_hundred: Number of people fully vaccinated per hundred people<br>
daily_vaccinations_per_million: Daily number of vaccinations per million people<br><br>

Prerequisites<br>
To run this project, you need to have the following installed:<br>

MySQL or PostgreSQL<br>
SQL client or command-line interface<br><br>

Setting Up the Database<br>


Create a Database<br>



Load the Data:<br>
Use the appropriate method (e.g., LOAD DATA INFILE for MySQL or COPY for PostgreSQL) to import the dataset into the covid19_data and covid_vaccination tables.<br>

Future Work<br>

Further data cleaning and normalization<br>
Advanced analytics and visualization<br>
Integration with other datasets for enriched analysis<br>
