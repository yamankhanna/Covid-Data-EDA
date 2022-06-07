SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE continent<>""
ORDER BY 1,2

Select location, SUM(new_deaths) as TotalDeathCount
From covid_deaths
Where continent=""
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestCases,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestCases,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths
Group by Location, Population, date
order by PercentPopulationInfected desc