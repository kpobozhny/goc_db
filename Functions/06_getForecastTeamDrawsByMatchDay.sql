DELIMITER $$
DROP FUNCTION IF EXISTS getForecastTeamDrawsByMatchDay;
$$

CREATE FUNCTION getForecastTeamDrawsByMatchDay(teamCode   VARCHAR(12),
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
           SELECT IF(getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) = getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode), 1, 0) AS tPoints
           FROM ForecastMatch fm
           WHERE fm.fSeasonCode = seasonCode
             AND fm.fTournamentCode = tournamentCode
             AND fm.fMatchDay <= matchDay
             AND fm.matchStatusCode='ED'
             AND fm.fHostTeamCode=teamCode

           UNION ALL

           SELECT IF(getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) = getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode), 1, 0) AS tPoints
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