
select *
from PortfolioProject.. CovidDeaths
order by 3,4

--select *
--from PortfolioProject.. CovidVaccinations
--order by 3,4

--Data I'm using
select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

--looking at total cases vs population
-- what % of people go covid
select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

--looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as HighestInfectionCount,Max(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Group by Location,Population
order by PercentPopulationInfected desc

--Showing Countries with highest death count per population

select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

--breaking things down by continent
-- showing continents with highest death count per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2


--total population vs vaccinations
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--using cte
with PopvsVac (continent, Location, Date, Population,New_Vaccinations,PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)

select *,(PeopleVaccinated/Population)*100
from PopvsVac

--creating view
 Create view PercentPopulationVaccinated as
 select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as PeopleVaccinated
--,(PeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated









