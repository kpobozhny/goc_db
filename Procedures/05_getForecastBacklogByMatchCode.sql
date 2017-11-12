DELIMITER $$

DROP PROCEDURE IF EXISTS getForecastBacklogByMatchCode;
$$

CREATE PROCEDURE getForecastBacklogByMatchCode(
  IN seasonCode     VARCHAR(9),
  IN tournamentCode VARCHAR(20),
  IN matchDay       TINYINT(4),
  IN matchCode VARCHAR(24))
  BEGIN



		SELECT 
				  t.tournamentName,
				  r.date,
				  ht.teamName AS hostTeam,
				  gt.teamName AS guestTeam,
                  r.resultCode
		FROM ForecastBacklog fb
			JOIN Result r ON fb.resultCode=r.resultCode
			JOIN Tournament t ON r.tournamentCode=t.tournamentCode
			JOIN Team ht ON r.hostTeamCode=ht.teamCode
			JOIN Team gt ON r.guestTeamCode=gt.teamCode
				WHERE fb.fSeasonCode = seasonCode
				AND fb.fTournamentCode = tournamentCode
				AND fb.fMatchDay = matchDay
                AND fb.resultCode NOT IN (SELECT DISTINCT fResultCode 
											FROM Forecast f
                                            WHERE f.fMatchCode=matchCode)
		ORDER BY r.date;
 
  END$$

DELIMITER ;