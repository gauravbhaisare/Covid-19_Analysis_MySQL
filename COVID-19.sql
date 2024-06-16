# Total rows in the table
use covid;
SELECT 
    COUNT(*) AS TOTAL_ROWS
FROM
    covid_deaths;

SELECT 
    COUNT(*)
FROM
    covid_vaccination;


# Describing the table

DESC covid_deaths;

DESC covid_vaccination;

#Exploring some important columns of the table covid_deaths and covid_vaccination.

SELECT 
    continent,
    location,
    `date`,
    total_cases,
    total_deaths,
    population
FROM
    covid_deaths
WHERE 
	continent IS NOT NULL;

SELECT 
    continent, 
    location, 
    `date`, 
    total_tests, 
    total_vaccinations
FROM
    covid_vaccination
WHERE
    continent IS NOT NULL;


#Checking for duplicate values

SELECT 
    location, `date`, continent, COUNT(*) AS count_dup
FROM
    covid_deaths
GROUP BY location , `date` , CONTINENT
HAVING count_dup > 1;

SELECT 
    location, `date`, continent, COUNT(*) AS count_dup
FROM
    covid_vaccination
GROUP BY location , `date` , continent
HAVING count_dup > 1;


#Total continents 

SELECT 
	DISTINCT continent
FROM
    covid_deaths;
    
    
#Total Countries in the data

SELECT 
    COUNT(DISTINCT location)
    AS TOTAL_COUNTRIES
FROM
    covid_deaths;
    
    
# Global Cases

SELECT 
    MAX(total_cases)
FROM
    covid_deaths
WHERE
    location = 'world';
    
#Global Deaths

SELECT 
    MAX(total_deaths)
FROM
    covid_deaths
WHERE
    location = 'world';


# Global Vaccinations
SELECT 
    MAX(total_vaccinations)
FROM
    covid_vaccination
WHERE
    location = 'world';
 
 
 # Mortality Rate
SELECT 
    MAX(total_deaths) / MAX(total_cases) * 100 AS mortality_rate
FROM
    covid_deaths
WHERE
    location = 'world';
    
    
#Percentage Of People Affected by Covid-19 Globally

SELECT 
     MAX(total_cases)/MAX(population) * 100 AS Percent_People_Affected
FROM
    covid_deaths
WHERE
    location = 'world';
    
    
 #Percentage Of People Deacesed by Covid-19 Globally
       
SELECT 
     MAX(total_deaths)/MAX(population) * 100 AS Percent_People_Affected
FROM
    covid_deaths
WHERE
    location = 'world';
    
    
 #Countries with the highest number of cases

SELECT 
    location, MAX(total_cases) AS `total_cases`
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY `total_cases` DESC;


#Countries with the highest number of deaths

SELECT 
    location, MAX(total_deaths) AS `total_deaths`
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY `total_deaths` DESC;



#Countries with the highest number of vaccinations

SELECT 
    location, MAX(total_vaccinations) AS `total_vaccinations`
FROM
    covid_vaccination
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY `total_vaccinations` DESC;


#PEOPLE FULLY VACCINATED
SELECT 
	LOCATION,
    CONTINENT,
    MAX(people_fully_vaccinated) PEOPLE_FULLY_VACCINATED
    
FROM
    COVID_VACCINATION
WHERE
    CONTINENT IS NOT NULL
GROUP BY LOCATION , CONTINENT
ORDER BY PEOPLE_FULLY_VACCINATED DESC;

#PERCENT PEOPLE FULLY VACCINATED
SELECT 
    CV.LOCATION,
    CD.POPULATION,
    MAX(CV.people_fully_vaccinated) AS people_fully_vaccinated,
    (MAX(CV.people_fully_vaccinated) / CD.POPULATION) * 100 AS people_fully_vaccinated_percent
FROM
    COVID_VACCINATION CV
JOIN 
    COVID_DEATHS CD ON CV.LOCATION = CD.LOCATION AND CV.DATE=CD.DATE
WHERE
    CV.CONTINENT IS NOT NULL
GROUP BY 
    CV.LOCATION,CD.POPULATION
ORDER BY 
    people_fully_vaccinated DESC;






/* Considering the highest value of total cases, 
which countries have the highest rate of infection in relation to population? */
SELECT 
continent,
    location,
    MAX(total_cases),
    population,
    ROUND(MAX((total_cases / population) * 100), 2) AS percent_population_infected
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population,continent
ORDER BY percent_population_infected DESC;



# Average fatality in a day across countries
SELECT 
    location, ROUND(AVG(new_deaths)) AS avg_fatallity_a_day
FROM
    covid_deaths
    WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY avg_fatality_a_day DESC;


# Average cases in a day across countries
SELECT 
    location, ROUND(AVG(new_cases)) AS avg_cases_a_day
FROM
    covid_deaths
    WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY avg_cases_a_day DESC;


# Average cases in a day across countries
SELECT 
    location, ROUND(AVG(new_vaccinations)) AS avg_vaccinations_a_day
FROM
    covid_vaccination
    WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY avg_vaccinations_a_day DESC;



# DEATH PERCENTAGE ACROSS WORLD FOR EACH DAY

SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY date;


# JOIN TWO table

SELECT 
    *
FROM
    covid_deaths cd
        JOIN
    covid_vaccination cv ON cd.location = cv.location
        AND cd.date = cv.date;
        

-- looking at population vs vaccinations
SELECT 
    cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaccination
FROM
    covid_deaths cd
        JOIN
    covid_vaccination cv ON cd.location = cv.location
    WHERE cd.continent IS NOT NULL
        AND cd.date = cv.date;
        


-- looking at population vs percentage of people vaccinated
WITH PopvsVac AS
(SELECT 
    cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations, 
    SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaccination
FROM
    covid_deaths cd
        JOIN
    covid_vaccination cv ON cd.location = cv.location
    WHERE cd.continent IS NOT NULL
        AND cd.date = cv.date)
        
	SELECT *,(total_vaccination/population)*100 AS PercentPopulationVaccinated FROM PopvsVac;

#COVID-19 SUMMARY
create VIEW SUMMARY AS
SELECT
    cd.location,
    cd.date,
    sum(CD.NEW_CASES),
    sum(CD.NEW_DEATHS),
    SUM(CV.NEW_VACCINATIONS),
    SUM(cd.total_deaths)as TOTAL_DEATHSS,
    SUM(cd.total_cases) AS TOTAL_CASESS,
    sum(cv.total_vaccinations)AS TOTAL_VACCINATIONS,
    (SUM(cd.total_deaths) / cd.population) * 100 AS death_percentage,
    (SUM(cd.total_cases) / cd.population) * 100 AS affected_percentage,
    (sum(cv.total_vaccinations)/cd.population)*100 as vacccination_percentage,
    (SUM(TOTAL_DEATHS)/SUM(TOTAL_CASES))*100 AS MORTALITY_RATE
FROM
    covid_deaths cd join covid_vaccination cv on cd.location=cv.location
WHERE
   cd.continent is not null and  cd.date=cv.date -- and cd.location="India"
GROUP BY
    cd.location,
    cd.date,
    cd.population
ORDER BY
    cd.location,
    cd.date;


#GLOBAL COVID-19 SUMMARY
SELECT 
    MAX(population) AS POPULATION,
    MAX(cd.total_cases) AS TOTAL_CASES,
    MAX(cd.total_deaths) AS TOTAL_DEATHS,
    MAX(cv.total_vaccinations) AS TOTAL_VACCINATION,
    MAX(cd.total_cases) / MAX(population) * 100 AS AFFECTED_POPULATION_PERCENTAGE,
    MAX(cd.total_deaths) / MAX(population) * 100 AS DECEASED_POPULATION_PERCENTAGE,
    MAX(cd.total_deaths) / MAX(cd.total_cases) * 100 AS MORTALITY_RATE
FROM
    covid_deaths cd
        JOIN
    covid_vaccination cv ON cd.location = cv.location
        AND cd.date = cv.date
WHERE
    cd.location = 'World';
    

#COVID-19 SUMMARY OF INDIA

SELECT 
    MAX(population) AS POPULATION,
    MAX(cd.total_cases) AS TOTAL_CASES,
    MAX(cd.total_deaths) AS TOTAL_DEATHS,
    MAX(cv.total_vaccinations) AS TOTAL_VACCINATION,
    MAX(cd.total_cases) / MAX(population) * 100 AS AFFECTED_POPULATION_PERCENTAGE,
    MAX(cd.total_deaths) / MAX(population) * 100 AS DECEASED_POPULATION_PERCENTAGE,
    MAX(cd.total_deaths) / MAX(cd.total_cases) * 100 AS MORTALITY_RATE
FROM
    covid_deaths cd
        JOIN
    covid_vaccination cv ON cd.location = cv.location
        AND cd.date = cv.date
WHERE
    cd.location = 'India';
    

#COVID-19 SUMMARY OF INDIA DAY BY DAY
SELECT
    cd.location,
    cd.date,
    SUM(CD.NEW_CASES) AS `new_cases`,
    SUM(CD.NEW_DEATHS)AS `new_deaths`,
    SUM(CV.NEW_VACCINATIONS)`new_vaccinations`,
    SUM(cd.total_deaths)AS `total_deaths`,
    SUM(cd.total_cases) AS `total_cases`,
    SUM(cv.total_vaccinations)AS `total_vaccinations`,
    (SUM(cd.total_deaths) / cd.population) * 100 AS death_percentage,
    (SUM(cd.total_cases) / cd.population) * 100 AS affected_percentage,
    (SUM(cv.total_vaccinations)/cd.population)*100 AS vacccination_percentage,
    (SUM(TOTAL_DEATHS)/SUM(TOTAL_CASES))*100 AS mortality_rate
FROM
    covid_deaths cd JOIN covid_vaccination cv ON cd.location=cv.location
WHERE
     cd.date=cv.date  AND cd.location="India"
GROUP BY
    cd.location,
    cd.date,
    cd.population
ORDER BY
    cd.location,
    cd.date;
    
    
    

