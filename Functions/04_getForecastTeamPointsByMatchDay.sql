DELIMITER $$
DROP FUNCTION IF EXISTS getForecastTeamPointsByMatchDay;
$$

CREATE FUNCTION getForecastTeamPointsByMatchDay(teamCode   VARCHAR(12),
                                            seasonCode     VARCHAR(9),
                                            tournamentCode VARCHAR(20),
                                            matchDay       INT)
  RETURNS INT
DETERMINISTIC
  BEGIN
    DECLARE points INT DEFAULT 0;

    SELECT IFNULL(sum(tPoints), 0)
    INTO points
    FROM (
           SELECT CASE
                  WHEN getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) > getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) THEN 3
                  WHEN getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) = getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) THEN 1
                  ELSE 0
                  END AS tPoints
           FROM ForecastMatch fm
           WHERE fm.fSeasonCode = seasonCode
             AND fm.fTournamentCode = tournamentCode
             AND fm.fMatchDay <= matchDay
             AND fm.matchStatusCode='ED'
             AND fm.fHostTeamCode=teamCode

           UNION ALL

           SELECT CASE
                  WHEN getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) > getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) THEN 3
                  WHEN getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) = getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) THEN 1
                  ELSE 0
                  END AS tPoints
           FROM ForecastMatch fm
           WHERE fm.fSeasonCode = seasonCode
             AND fm.fTournamentCode = tournamentCode
             AND fm.fMatchDay <= matchDay
			 AND fm.matchStatusCode='ED'
             AND fm.fGuestTeamCode=teamCode
         ) Points;

    RETURN points;
  END$$

DELIMITER ;