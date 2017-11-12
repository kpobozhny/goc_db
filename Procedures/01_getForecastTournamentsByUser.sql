-- Receiving a list of tournaments, in which the user is invilved

DELIMITER $$

DROP PROCEDURE IF EXISTS getForecastTournamentsByUser;
$$

CREATE PROCEDURE getForecastTournamentsByUser(
  IN userCode VARCHAR(10)

)
  BEGIN
    SELECT
      ft.fTournamentCode AS tournamentCode,
      ft.fTournamentName AS tournamentName,
      ts.fStatusName AS tournamentStatus

    FROM ForecastTournament ft
      JOIN ForecastTournamentStatus ts ON ft.fTournamentStatusCode = ts.fStatusCode
      JOIN ForecastTournamentTeams tt ON ft.fTournamentCode = tt.fTournamentCode
      JOIN ForecastTeam t ON tt.fTeamCode=t.fTeamCode
    WHERE t.fUserCode = userCode 
    AND ft.fTournamentStatusCode='I';
  END$$

DELIMITER ;


