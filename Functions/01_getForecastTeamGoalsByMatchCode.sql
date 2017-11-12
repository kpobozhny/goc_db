DELIMITER $$
DROP FUNCTION IF EXISTS getForecastTeamGoalsByMatchCode;
$$

CREATE FUNCTION getForecastTeamGoalsByMatchCode(teamCode       VARCHAR(12),
												matchCode VARCHAR(30))
  RETURNS INT
DETERMINISTIC
  BEGIN
    DECLARE goals INT DEFAULT 0;

    SELECT IFNULL(sum(teamGoals), 0)
    INTO goals
    FROM (
           SELECT IFNULL(f.fPoints, 0) AS teamGoals
           FROM Forecast f
           WHERE f.forecastTeamCode=teamCode
             AND f.fMatchCode=matchCode
         ) Goals;

    RETURN goals;
  END$$

DELIMITER ;