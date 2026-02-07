SELECT
    City,
    State,
    COUNT(*) AS AppearanceCount
FROM (
    SELECT City, State FROM dbo.BookItWaterford2023
    UNION ALL
    SELECT City, State FROM dbo.Clawson5KMile2023
    UNION ALL
    SELECT City, State FROM dbo.LetsMoveMacomb2023
    UNION ALL
    SELECT City, State FROM LONewYears2023
    UNION ALL
    SELECT City, State FROM OrionVeteransRun2023
    UNION ALL
    SELECT City, State FROM CantonTurkeyTrot2022
    UNION ALL
    SELECT City, State FROM EggnogJog2023
    UNION ALL
    SELECT City, State FROM BillRoney31st
	union all
	select city, state from AnchorBay5kFishfly2023
	union all
	select city, state from BerkleyDays45th
	union all
	select city, state from BigBirdRun45th
	union all
	select city, state from Chesterfield5K3rd
	union all
	select city, state from DetroitWine5K2023
	union all
	select city, state from FestivusCelebration2023
	union all
	select city, state from ForeverHome2023
	union all
	select city, state from FosterKids5K2023
	union all
	select city, state from HalloweenHunger2023
	union all
	select city, state from Hansons1stWednesday2023
	union all
	select city, state from Hansons3MileXC2023
	union all
	select city, state from IkeWorldChangers2023
	union all
	select city, state from IronMike2023
	union all
	select city, state from JoeManfreda2023
	union all
	select city, state from PiDay5K2023
	union all
	select city, state from RunNature2023
	union all
	select city, state from RunningHawgs2023
	union all
	select city, state from RunningHawgs2023
	union all
	select city, state from SprintSplash2023
	union all
	select city, state from Sterlingfast5K2023
) t
GROUP BY City, State
ORDER BY AppearanceCount DESC;
