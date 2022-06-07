/*
Covid 19 Data Exploration 
Skills used: Creating Tables, Loading CSV files in tables, Joins, CTE's, Windows Functions, Aggregate Functions
*/

-- Creating Covid_Deaths Table to load CSV File

CREATE TABLE `portfolioproject`.`covid_deaths` (
  `iso_code` VARCHAR(15) NOT NULL,
  `continent` VARCHAR(25) NULL DEFAULT NULL,
  `location` VARCHAR(40) NOT NULL,
  `date` VARCHAR(10) NOT NULL,
  `population` VARCHAR(25) NOT NULL,
  `total_cases` INT NULL DEFAULT NULL,
  `new_cases` INT NULL DEFAULT NULL,
  `new_cases_smoothed` DECIMAL(10,4) NULL DEFAULT NULL,
  `total_deaths` INT NULL DEFAULT NULL,
  `new_deaths` INT NULL DEFAULT NULL,
  `new_deaths_smoothed` INT NULL DEFAULT NULL,
  `total_cases_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_cases_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_cases_smoothed_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `total_deaths_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_deaths_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_deaths_smoothed_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `reproduction_rate` DECIMAL(10,4) NULL DEFAULT NULL,
  `icu_patients` INT NULL DEFAULT NULL,
  `icu_patients_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `hosp_patients` INT NULL DEFAULT NULL,
  `hosp_patients_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `weekly_icu_admissions` DECIMAL(10,4) NULL DEFAULT NULL,
  `weekly_icu_admissions_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `weekly_hosp_admissions` DECIMAL(10,4) NULL DEFAULT NULL,
  `weekly_hosp_admissions_per_million` DECIMAL(10,4) NULL DEFAULT NULL);
  
-- Loading CSV file into table Covid_Deaths  

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv'
INTO TABLE covid_deaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM covid_deaths;

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent<>""
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you get Covid Positive in India

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE continent<>""
AND location="India";

-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as PeopleInfected
FROM covid_deaths
WHERE location="India";

-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestCases, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM covid_deaths
GROUP BY location
ORDER BY PercentagePopulationInfected DESC;

-- Countries with Highest Death Count per Population

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM covid_deaths
WHERE continent<>""
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM covid_deaths
WHERE continent=""
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM covid_deaths
WHERE continent<>""
GROUP BY date;

-- Creating Covid_Vaccinations Table to load CSV File

CREATE TABLE `portfolioproject`.`covid_vaccinations` (
  `iso_code` VARCHAR(15) NOT NULL,
  `continent` VARCHAR(40) NULL DEFAULT NULL,
  `location` VARCHAR(45) NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  `new_tests` INT NULL DEFAULT NULL,
  `total_tests` INT NULL DEFAULT NULL,
  `total_tests_per_thousand` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_tests_per_thousand` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_tests_smoothed` INT NULL DEFAULT NULL,
  `new_tests_smoothed_per_thousand` DECIMAL(10,4) NULL DEFAULT NULL,
  `positive_rate` DECIMAL(10,4) NULL DEFAULT NULL,
  `tests_per_case` DECIMAL(10,4) NULL DEFAULT NULL,
  `tests_units` VARCHAR(45) NULL DEFAULT NULL,
  `total_vaccinations` INT NULL DEFAULT NULL,
  `people_vaccinated` INT NULL DEFAULT NULL,
  `people_fully_vaccinated` INT NULL DEFAULT NULL,
  `new_vaccinations` INT NULL DEFAULT NULL,
  `new_vaccinations_smoothed` INT NULL DEFAULT NULL,
  `total_vaccinations_per_hundred` DECIMAL(10,4) NULL DEFAULT NULL,
  `people_vaccinated_per_hundred` DECIMAL(10,4) NULL DEFAULT NULL,
  `people_fully_vaccinated_per_hundred` DECIMAL(10,4) NULL DEFAULT NULL,
  `new_vaccinations_smoothed_per_million` DECIMAL(10,4) NULL DEFAULT NULL,
  `stringency_index` DECIMAL(10,4) NULL DEFAULT NULL,
  `population_density` DECIMAL(10,4) NULL DEFAULT NULL,
  `median_age` DECIMAL(10,4) NULL DEFAULT NULL,
  `aged_65_older` DECIMAL(10,4) NULL DEFAULT NULL,
  `aged_70_older` DECIMAL(10,4) NULL DEFAULT NULL,
  `gdp_per_capita` DECIMAL(10,4) NULL DEFAULT NULL,
  `extreme_poverty` DECIMAL(10,4) NULL DEFAULT NULL,
  `cardiovasc_death_rate` DECIMAL(10,4) NULL DEFAULT NULL,
  `diabetes_prevalence` DECIMAL(10,4) NULL DEFAULT NULL,
  `female_smokers` DECIMAL(10,4) NULL DEFAULT NULL,
  `male_smokers` DECIMAL(10,4) NULL DEFAULT NULL,
  `handwashing_facilities` DECIMAL(10,4) NULL DEFAULT NULL,
  `hospital_beds_per_thousand` DECIMAL(10,4) NULL DEFAULT NULL,
  `life_expectancy` DECIMAL(10,4) NULL DEFAULT NULL,
  `human_development_index` DECIMAL(10,4) NULL DEFAULT NULL);

-- Loading CSV file into table Covid_Vaccinations 

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidVaccinations.csv'
INTO TABLE covid_vaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM covid_vaccinations;

-- Joining both the Tables

SELECT * 
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>"";

-- Using Window Function to calculate People Vaccinated Till particular Date in a country

SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_deaths.population, covid_vaccinations.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS PeopleVaccinatedTillDate
FROM covid_deaths JOIN covid_vaccinations
ON covid_deaths.location=covid_vaccinations.location
AND covid_deaths.date=covid_vaccinations.date
WHERE covid_deaths.continent<>""
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

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

-- Creating a Table for further Visualisation In Tableau

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
