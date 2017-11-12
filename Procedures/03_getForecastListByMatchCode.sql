-- Receiving a list of tournaments, in which the user is invilved

DELIMITER $$

DROP PROCEDURE IF EXISTS getForecastListByMatchCode;
$$

CREATE PROCEDURE getForecastListByMatchCode(
  IN matchCode VARCHAR(24)
)
  BEGIN
  
	SELECT 	Main.tournamentName,
			Main.date,
			Main.hostTeam,
			Main.guestTeam,
			Main.hostForecast_GoalsByHost,
			Main.hostForecast_GoalsByGuest,
		    f1.fGoalsByHost AS guestForecast_GoalsByHost,
		    f1.fGoalsByGuest AS guestForecast_GoalsByGuest,            
			Main.result_GoalsByHost,
			Main.result_GoalsByGuest,
			Main.hostPoints,
            f1.fPoints AS guestPoints, 
            Main.tournamentCode,
			Main.hostTeamCode,
			Main.guestTeamCode,
			Main.resultCode,
			Main.forecastStatusCode,
            Main.forecastMatchCode,
            Main.forecastHostTeamCode,
            Main.forecastGuestTeamCode
			FROM (
    
			SELECT
			  r.tournamentCode,
			  r.hostTeamCode AS hostTeamCode,
			  r.guestTeamCode AS guestTeamCode,
			  t.tournamentName,
			  r.date,
			  ht.teamName AS hostTeam,
			  gt.teamName AS guestTeam,
			  f.fGoalsByHost AS hostForecast_GoalsByHost,
			  f.fGoalsByGuest AS hostForecast_GoalsByGuest,
			  r.goalsByHost AS result_GoalsByHost,
			  r.goalsByGuest AS result_GoalsByGuest,
			  f.fPoints AS hostPoints,
			  f.forecastStatusCode,
              f.fResultCode AS resultCode,
              f.fMatchCode AS forecastMatchCode,
              fm.fHostTeamCode AS forecastHostTeamCode,
              fm.fGuestTeamCode AS forecastGuestTeamCode
			FROM Result r
				JOIN Tournament t ON r.tournamentCode=t.tournamentCode
				JOIN Team ht ON r.hostTeamCode=ht.teamCode
				JOIN Team gt ON r.guestTeamCode=gt.teamCode
				 JOIN Forecast f ON f.fResultCode=r.resultCode AND f.fMatchCode=matchCode
				 JOIN ForecastMatch fm ON f.fMatchCode=fm.matchCode  
			 WHERE fm.fHostTeamCode=f.forecastTeamCode) Main
             
       JOIN Forecast f1 ON f1.fResultCode=Main.resultCode 
						AND f1.fMatchCode=Main.forecastMatchCode 	
                        AND f1.forecastTeamCode=Main.forecastGuestTeamCode
	;
  END$$

DELIMITER ;


