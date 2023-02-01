Select*
From [covid portfolio project].dbo.['owid-covid-data$']
where continent is not null
order by 3,4

-- select start with point 

select location,date,total_cases,total_deaths,population
From [covid portfolio project].dbo.['owid-covid-data$']
where location like'india'
and continent is not null
order by 1,2

--looking at total cases vs total death

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100as death_percentage
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'india'
where continent is not null
order by 1,2

-- Looking at total cases vs population

select location,date,total_cases,population,(total_cases/population)*100as infected_ratio
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'india'
where continent is not null
order by 1,2

--Looking at counties with high rate of infection compared to population

select location,max(total_cases) as infect_count,population,max((total_cases/population))*100 as percent_infectedcount
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'%states%'
group by location,population
order by 4 desc

--Looking at counties with high rate of death compared to population

select location, max(cast(total_deaths as int)) as death_count
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'india'
group by location,population
where continent is not null
order by 2 desc

--LET's group things by continent
--Showing continent the highest deaths count

select continent, max(cast(total_deaths as int)) as death_count
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'india'
where continent is not null
group by continent
order by 2 desc

--GLOBAL NUMBERS

select sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From [covid portfolio project].dbo.['owid-covid-data$']
where continent is not null
--group by date
order by 1,2

-- joining the death and vaccination table
select *
From [covid portfolio project].[dbo].['owid-covid-data$'] dea
join [covid portfolio project].dbo.['covid vaccination$'] vac
	on dea.location = vac.location
	and dea.date = vac.date


--looking at Total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
From [covid portfolio project].[dbo].['owid-covid-data$'] dea
join [covid portfolio project].dbo.['covid vaccination$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepoplevaccinated
--(rollingpepoplevaccinated/population)*100
From [covid portfolio project].[dbo].['owid-covid-data$'] dea
join [covid portfolio project].dbo.['covid vaccination$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--creating CTE

with popvsvac (continent,location,date,population,new_vaccinations,rollingpepoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepoplevaccinated
--(rollingpepoplevaccinated/population)*100
From [covid portfolio project].[dbo].['owid-covid-data$'] dea
join [covid portfolio project].dbo.['covid vaccination$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
)
select*, (rollingpepoplevaccinated/population)*100 as percentpopulationvaccinated
from popvsvac

--creating view to save the data for visualization

create view percentpopulationvaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepoplevaccinated
--(rollingpepoplevaccinated/population)*100
From [covid portfolio project].[dbo].['owid-covid-data$'] dea
join [covid portfolio project].dbo.['covid vaccination$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated




select location,population,date,max(total_cases) as infect_count,population,max((total_cases/population))*100 as percent_infectedcount
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'%states%'
group by location,population,date
order by 6 desc
