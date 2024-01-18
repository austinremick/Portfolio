-- Data source: https://ourworldindata.org/covid-deaths

select *
from CovidDeaths
where continent is not null
order by 3,4

/* select *
from CovidVaccinations
order by 3,4 */

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid
select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths)/NULLIF(CONVERT(float, total_cases),0))*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by location, date

-- Looking at total cases vs population
-- Shows what percentage of the population got Covid
select location, date, Population, total_cases, (CONVERT(float, total_cases)/NULLIF(CONVERT(float, Population),0))*100 as PercentPopInfected
from CovidDeaths
where location like '%states%'
order by location, date

-- Looking at countries with highest infection rate compared to population

select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((CONVERT(float, total_cases)/NULLIF(CONVERT(float, Population),0)))*100 as MAXPercentPopInfected
from CovidDeaths
-- where location like '%states%'
group by Location, Population
order by MAXPercentPopInfected desc

-- Showing countries with highest death count per population

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
-- where location like '%states%'
where continent is not NULL
group by Location
order by TotalDeathCount desc

-- Showing CONTINENTS with the highest death count

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
-- where location like '%states%'
where continent is NULL
group by location
order by TotalDeathCount desc

