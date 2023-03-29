-- Total cases to total deaths depicting probability of dying if contract covid in country

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST(total_cases as float))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2;

-- Total number of persons with Covid in comparison to the population
-- Percentage of the population who got Covid
SELECT location, date, total_cases, population, CAST(total_cases as float)/population as InfectionPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location = 'Dominica'
ORDER BY 1,2

-- Countries with Highest Infection Raate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases as float)/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Percentage of population which died from Covid

SELECT location, population, MAX(CAST(total_deaths AS float)) AS TotalDeathCount, MAX(CAST(total_cases as float)/population)*100 as PercentPopulationDied
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null 
GROUP BY location, population
ORDER BY TotalDeathCount DESC;

-- Deaths by continent

SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is null 
AND location <> '%income%'
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Global Numbers by date
SELECT date, SUM(new_cases) as DailyNewCases, SUM(new_deaths) as DailyNewDeaths, SUM(new_deaths)/SUM(new_cases) * 100 as DailyDeathofNewCases
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL 
And new_cases > 0
GROUP BY date
ORDER BY date;

-- Global Number totals
SELECT SUM(new_cases) as DailyNewCases, SUM(new_deaths) as DailyNewDeaths, SUM(new_deaths)/SUM(new_cases) * 100 as DailyDeathofNewCases
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL 
And new_cases > 0;
