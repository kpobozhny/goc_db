-- Receiving a list of tournaments, in which the user is invilved

DELIMITER $$

DROP PROCEDURE IF EXISTS getForecastMatchesByMatchDay;
$$

CREATE PROCEDURE getForecastMatchesByMatchDay(
  IN seasonCode VARCHAR(9),
  IN tournamentCode VARCHAR(20),
  IN matchDay TINYINT(4)

)
  BEGIN
    SELECT
      fm.matchCode AS matchCode,
      fm.fHostTeamCode AS hostTeamCode,
      fm.fGuestTeamCode AS guestTeamCode,
      ht.fTeamName AS hostTeamName,
      gt.fTeamName AS guestTeamName,
      getForecastTeamGoalsByMatchCode(fm.fHostTeamCode, fm.matchCode) AS hostGoals,
      getForecastTeamGoalsByMatchCode(fm.fGuestTeamCode, fm.matchCode) AS guestGoals

    FROM ForecastMatch fm
		 JOIN ForecastTeam ht ON fm.fHostTeamCode=ht.fTeamCode
         JOIN ForecastTeam gt ON fm.fGuestTeamCode=gt.fTeamCode
      -- JOIN Forecast f ON fm.matchCode = f.fMatchCode

    WHERE fm.fSeasonCode=seasonCode
      AND fm.fTournamentCode=tournamentCode
      AND fm.fMatchDay=matchDay;
  END$$

DELIMITER ;


