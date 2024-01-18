-- GLOBAL NUMBERS

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from coviddeaths
where continent is not NULL
-- group by date
order by sum(new_cases)



--- Looking at total population vs vaccinations in the entire world

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
--- Partitioned by dea.location because we want the rolling count to start over with each new country
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by dea.location, dea.date

--- Using CTE (the CTE allows for us to do (RollingPeopleVacinated/Population)*100 to get a rolling percentage of total population vaccinated)

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) -- Number of columns in CTE must equal number of columns in table
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
--- Partitioned by dea.location because we want the rolling count to start over with each new country
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
-- order by dea.location, dea.date
)
select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentVaccinated
from PopvsVac

--- Using Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
--- Partitioned by dea.location because we want the rolling count to start over with each new country
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
-- where dea.continent is not null
-- order by dea.location, dea.date

select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentVaccinated
from #PercentPopulationVaccinated


--- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
--- Partitioned by dea.location because we want the rolling count to start over with each new country
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
-- order by dea.location, dea.date

--- After running the above view, go to views on the left and refresh
--- This view is now permanent and can be queried on (see below)

select *
from PercentPopulationVaccinated