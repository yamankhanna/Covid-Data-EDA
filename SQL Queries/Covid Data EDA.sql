SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE location="India";

SELECT location, date, total_cases, population, (total_cases/population)*100 as PeopleInfected
FROM covid_deaths
WHERE location="India";

SELECT location, population, MAX(total_cases) as HighestCases, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM covid_deaths
GROUP BY location
ORDER BY PercentagePopulationInfected DESC;

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM covid_deaths
WHERE continent<>""
GROUP BY location
ORDER BY TotalDeathCount DESC;

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM covid_deaths
WHERE continent=""
GROUP BY location
ORDER BY TotalDeathCount DESC;

SELECT date, SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM covid_deaths
WHERE continent<>""
GROUP BY date;

SELECT * 
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date;

SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>"";


SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS PeopleVaccinatedTillDate
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>""
ORDER BY 2,3;

WITH PopulationVsVaccinated AS
(
Select covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS PeopleVaccinatedTillDate
from covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
and covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>""
ORDER BY 2,3
)
SELECT *, (PeopleVaccinatedTillDate/Population)*100 as PercentagePeopleVaccinated 
FROM PopulationVsVaccinated;



CREATE TABLE TotalPeopleVaccinated
(
continent VARCHAR(45) NULL,
location varchar(45) NOT NULL,
date varchar(10)  NOT NULL,
population VARCHAR(15) NOT NULL,
new_vaccinations INT NULL,
PeopleVaccinatedTillDate INT);

INSERT INTO TotalPeopleVaccinated
SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS PeopleVaccinatedTillDate
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>""
ORDER BY 2,3;

SELECT *, (PeopleVaccinatedTillDate/population)*100 AS PercentagePeopleVaccinated
FROM totalpeoplevaccinated;

SELECT *
FROM totalpeoplevaccinated;