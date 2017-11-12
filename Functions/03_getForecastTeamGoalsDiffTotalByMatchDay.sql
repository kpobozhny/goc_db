DELIMITER $$
DROP FUNCTION IF EXISTS getForecastTeamGoalsDiffTotalByMatchDay;
$$

CREATE FUNCTION getForecastTeamGoalsDiffTotalByMatchDay(teamCode       VARCHAR(12),
                                            seasonCode     VARCHAR(9),
                                            tournamentCode VARCHAR(20),
                                            matchDay       INT)
  RETURNS INT
DETERMINISTIC
  
    BEGIN
    DECLARE goals INT DEFAULT 0;
    DECLARE opponentsGoals INT DEFAULT 0;

    SELECT IFNULL(sum(teamGoals), 0)
    INTO goals
    FROM (
           SELECT IFNULL(f.fPoints, 0) AS teamGoals
           FROM Forecast f
				JOIN ForecastMatch fm ON f.fMatchCode=fm.matchCode
           WHERE fm.fSeasonCode = seasonCode
             AND fm.fTournamentCode = tournamentCode
             AND fm.fMatchDay <= matchDay
             AND f.forecastTeamCode=teamCode
             AND f.forecastStatusCode IN ('D', 'C')
         ) Goals;
         
        SELECT IFNULL(sum(opTeamGoals), 0)
    INTO opponentsGoals
    FROM (
           SELECT IFNULL(f.fPoints, 0) AS opTeamGoals
           FROM Forecast f
				JOIN ForecastMatch fm ON f.fMatchCode=fm.matchCode
           WHERE fm.fSeasonCode = seasonCode
             AND fm.fTournamentCode = tournamentCode
             AND fm.fMatchDay <= matchDay
             AND (fm.fHostTeamCode=teamCode OR fm.fGuestTeamCode=teamCode)
			 AND f.forecastTeamCode!=teamCode
             AND f.forecastStatusCode IN ('D', 'C')
         ) opGoals;     

    RETURN goals-opponentsGoals;
  END$$

DELIMITER ;