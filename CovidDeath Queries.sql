--Looking at total population vs vaccinations

SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
FROM PortfolioProject..CovidDeaths$ death
JOIN PortfolioProject..CovidVaccinations$ vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent is not NULL
ORDER BY 1, 2, 3;

--Total Numbers by country/locaation
SELECT DISTINCT death.continent, death.location, death.date, death.population, CAST(vaccine.new_vaccinations AS float) AS NewVaccinations, 
SUM(CAST(vaccine.new_vaccinations AS float)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingVaccinationNumbers,
FROM PortfolioProject..CovidDeaths$ death
JOIN PortfolioProject..CovidVaccinations$ vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent is not NULL
ORDER BY 2, 3;

-- Use of CTE with population vs vacinnation

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinationNumbers) 
as 
(
SELECT death.continent, death.location, death.date, death.population, CAST(vaccine.new_vaccinations AS float) AS NewVaccinations, 
SUM(CAST(vaccine.new_vaccinations AS float)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingVaccinationNumbers
FROM PortfolioProject..CovidDeaths$ death
JOIN PortfolioProject..CovidVaccinations$ vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent is not NULL
)
SELECT *, (RollingVaccinationNumbers/population)*100
FROM PopvsVac;


--Temporary Table
DROP TABLE IF EXISTS #PercentPorpulationVaccinated
CREATE TABLE #PercentPorpulationVaccinated

(Continent nvarchar(255), 
Location nvarchar(255),
date datetime,
Population numeric,
NewVaccinations numeric, 
RollingVaccinationNumbers numeric
)

INSERT INTO #PercentPorpulationVaccinated
SELECT death.continent, death.location, death.date, death.population, CAST(vaccine.new_vaccinations AS float) AS NewVaccinations, 
SUM(CAST(vaccine.new_vaccinations AS float)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingVaccinationNumbers
FROM PortfolioProject..CovidDeaths$ death
JOIN PortfolioProject..CovidVaccinations$ vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent is not NULL

SELECT *, (RollingVaccinationNumbers/population)*100 as PercentofPopulation
FROM #PercentPorpulationVaccinated;

--Creating view to store data for later visualizations

CREATE VIEW PercentPorpulationVaccinated as
SELECT death.continent, death.location, death.date, death.population, CAST(vaccine.new_vaccinations AS float) AS NewVaccinations, 
SUM(CAST(vaccine.new_vaccinations AS float)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingVaccinationNumbers
FROM PortfolioProject..CovidDeaths$ death
JOIN PortfolioProject..CovidVaccinations$ vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent is not NULL

