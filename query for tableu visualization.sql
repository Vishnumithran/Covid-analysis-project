--Queries for visualization



--GLOBAL NUMBERS

select sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From [covid portfolio project].dbo.['owid-covid-data$']
where continent is not null
--group by date
order by 1,2


--Showing continent the highest deaths count

select continent, max(cast(total_deaths as int)) as death_count
From [covid portfolio project].dbo.['owid-covid-data$']
--where location like'india'
where continent is not null
group by continent
order by 2 desc




--country with highest infection rate compared to population

Select location ,population,MAX(total_cases) as HighestInfected_count,MAX((Total_deaths/total_cases))*100 as PopulationInfected_Percentage
from CovidDeaths
--where location = 'India'
GROUP BY location,population
ORDER BY PopulationInfected_Percentage desc 




--country with highest infection rate compared to population

Select location ,population,date,MAX(total_cases) as HighestInfected_count,MAX((Total_deaths/total_cases))*100 as PopulationInfected_Percentage
from CovidDeaths
--where location = 'India'
GROUP BY location,population,date 
ORDER BY PopulationInfected_Percentage desc 