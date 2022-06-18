Select *
from PortfolioProject..CovidDeaths
order by 3,4 

-- Select data that I am going to need

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2



-- Looking at total cases vs total deaths 
-- shows likelihood of dying if contract covid in Lebanon

Select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where location like '%lebanon%' 
order by 1,2

-- Looking at total cases vs Population 
-- shows percentage to contract covid in Lebanon 
Select location, date, total_cases, population,  (total_cases/population)*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
Where location like '%lebanon%' 
--  and (total_cases/population)*100  > 5 
order by 1,2

-- Looking at countries with highest infection rate compared to population 

Select location, MAX(total_cases) as HighestInfectionCount, population,  MAX((total_cases/population)*100) as InfectedPercentage
from PortfolioProject..CovidDeaths
Group by location, population
order by InfectedPercentage desc 

-- Showing countries with Highest Death count per Population

Select location, MAX(cast(total_deaths as int)) as DeathCount
from PortfolioProject..CovidDeaths
Where continent is not Null
Group by location
order by DeathCount desc 



Select location, MAX(cast(total_deaths as int)) as DeathCount, population,  MAX((cast(total_deaths as int)/population)*100) as DeathPercentage
from PortfolioProject..CovidDeaths
Where continent is not Null
Group by location, population
order by DeathPercentage desc 


-- Showing the continents with highest death count 

Select continent, MAX(cast(total_deaths as int)) as DeathCount
from PortfolioProject..CovidDeaths
Where continent is not Null
Group by continent
order by DeathCount desc 

-- Global numbers 

Select date, Sum(new_cases) as NewCases, Sum(cast(new_deaths as int)) NewDeaths, SUM(cast(new_deaths as int))*100/Sum(new_cases) as DeathPercentage 
from PortfolioProject..CovidDeaths
Where continent is not Null
Group by date 
order by 1  

Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
order by 2,3


-- Looking at total population vs Vaccinations 

Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
order by 2,3

-- Using CTE to query with columns we create 


With PopvsVac ( Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated )
as 
(
Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null
)
Select *, (RollingPeopleVaccinated/Population)*100 
from PopvsVac



-- Using a table  to query with columns we create
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null

Select *, (RollingPeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated
order by 2,3



-- Creating View to store data for later visualizations 

Create View PercentagePopulationVaccinated as 
Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidDeaths vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not Null


Select * 
from PercentagePopulationVaccinated




