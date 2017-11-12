DELIMITER $$

DROP PROCEDURE IF EXISTS getForecastTeamsOrderByMatchDay;
$$

CREATE PROCEDURE getForecastTeamsOrderByMatchDay(
  IN seasonCode     VARCHAR(9),
  IN tournamentCode VARCHAR(20),
  IN matchDay       TINYINT(4))
  BEGIN

    IF (matchDay <= 0)
    THEN
      SELECT
        'place',
        'teamCode',
        'teamName',
        'goalsScored',
        'goalsDiff',
        'points'
      LIMIT 0;
    ELSE

      SET @row_number = 0;

      SELECT
        CAST(@row_number := @row_number + 1 AS CHAR) AS place,
        teamCode,
        teamName,
        won,
        drawn,
        lost,
        goalsScored,
        goalsDiff,
        points
      FROM (
             SELECT
               TeamList.teamCode,
               TeamList.teamName,
               getForecastTeamWinsByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay)         AS won,
               getForecastTeamDrawsByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay)         AS drawn,
               getForecastTeamLosesByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay)         AS lost,
               getForecastTeamPointsByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay)         AS points,
               getForecastTeamGoalsTotalByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay)     AS goalsScored,
               getForecastTeamGoalsDiffTotalByMatchDay(TeamList.teamCode, seasonCode, tournamentCode, matchDay) AS goalsDiff
             FROM (
                    SELECT DISTINCT
                      ftt.fTeamCode AS teamCode,
                      ft.fTeamName AS teamName
                    FROM ForecastTournamentTeams ftt
                    JOIN ForecastTeam ft ON ftt.fTeamCode=ft.fTeamCode
                    WHERE ftt.fTournamentCode = tournamentCode
                          AND ftt.fSeasonCode = seasonCode) TeamList
             ORDER BY points DESC,
               goalsDiff DESC,
               goalsScored DESC) TeamsOrdered;
    END IF;
  END$$

DELIMITER ;