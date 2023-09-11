Select *
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order By 3,4


--Select *
--From PortfolioProject.dbo.CovidVaccinations
--Order By 3,4


Select location, date,total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths 
Order By 1,2

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Order By 1,2

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
Where location like '%kyrgyzstan%'
Where continent is not null
order by 1,2



Select location, date, population,total_cases, (total_cases/population)*100 as infectedpercentage
From PortfolioProject..CovidDeaths
Where location like '%Kyrgyzstan%'
Where continent is not null
order by 1,2


Select location, population,MAX(total_cases) as HighestInfectionCount,MAX ((total_cases/population))*100 as infectedpercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
order by 4 DESC

Select location, population, Max(total_deaths) as HighestDeathCount,MAX ((CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Group by location,population
Order by 4 DESC


Select location,MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by 2 desc 



Select location,MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
order by 2 desc 


Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths,CONVERT(float,SUM(new_deaths)/NULLIF(CONVERT(float,SUM(new_cases)),0))*100 as DeathsPercentage 
From PortfolioProject..CovidDeaths
Where continent is not null
--group by date
order by 3 desc


With PopvsVac (continent, location,date, population, new_vaccinations, RollingPeopleVaccinated)
As 
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
  SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
  --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.date = vac.date
	And dea.location = vac.location
Where dea.continent is not null
--Order by 2,3
)
Select *
From PopvsVac



DROP TABLE IF exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
  SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
  --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.date = vac.date
	And dea.location = vac.location
Where dea.continent is not null
--Order by 2,3

Select *,(RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated



Select SUM(new_cases) as Total_cases,SUM(new_deaths) as Total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2



Select continent,MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
  SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
  --,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.date = vac.date
	And dea.location = vac.location
Where dea.continent is not null
--Order by 2,3


















