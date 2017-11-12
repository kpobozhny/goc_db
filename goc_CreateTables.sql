-- create 'Country' table
CREATE TABLE `Country` (
  `countryId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `countryCode` VARCHAR(3)   NOT NULL,
  `countryName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`countryId`),
  UNIQUE KEY `countryCode` (`countryCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'Season' table
CREATE TABLE `Season` (
  `seasonId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `seasonCode` VARCHAR(9)   NOT NULL,
  `seasonName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`seasonId`),
  UNIQUE KEY `seasonCode` (`seasonCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'Tournament' table
CREATE TABLE `Tournament` (
  `tournamentId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `tournamentCode` VARCHAR(20)  NOT NULL,
  `tournamentName` VARCHAR(255) NOT NULL,
  `countryCode`      VARCHAR(3)            DEFAULT NULL,
  PRIMARY KEY (`tournamentId`),
  UNIQUE KEY `tournamentCode` (`tournamentCode`),
  KEY `FK_countryCode` (`countryCode`),
  CONSTRAINT `FK_countryCode` FOREIGN KEY (`countryCode`) REFERENCES `Country` (`countryCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'Team' table
CREATE TABLE `Team` (
  `teamId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `teamCode` VARCHAR(6)   NOT NULL,
  `teamName` VARCHAR(255) NOT NULL,
  `teamCountryCode`      VARCHAR(3)            DEFAULT NULL,
  PRIMARY KEY (`teamId`),
  UNIQUE KEY `teamCode` (`teamCode`),
  UNIQUE KEY `teamName` (`teamName`),
  KEY `FK_teamCountryCode` (`teamCountryCode`),
  CONSTRAINT `FK_teamCountryCode` FOREIGN KEY (`teamCountryCode`) REFERENCES `Country` (`countryCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'Result' table
CREATE TABLE `Result` (
  `resultId`     BIGINT(20) NOT NULL AUTO_INCREMENT,
  `resultCode`   VARCHAR(24)         DEFAULT NULL,
  `date`         DATETIME            DEFAULT NULL,
  `seasonCode`     VARCHAR(9) NOT NULL,
  `tournamentCode` VARCHAR(20) NOT NULL,
  `matchDay`     TINYINT(4) NOT NULL,
  `hostTeamCode`  VARCHAR(6) NOT NULL,
  `guestTeamCode`   VARCHAR(6) NOT NULL,
  `goalsByHost`  TINYINT(4)          DEFAULT NULL,
  `goalsByGuest` TINYINT(4)          DEFAULT NULL,
  PRIMARY KEY (`resultId`),
  UNIQUE KEY `resultCode` (`resultCode`),
  KEY `FK_guestTeamCode` (`guestTeamCode`),
  KEY `FK_hostTeamCode` (`hostTeamCode`),
  KEY `FK_seasonCode` (`seasonCode`),
  KEY `FK_tournamentCode` (`tournamentCode`),
  CONSTRAINT `FK_tournamentCode` FOREIGN KEY (`tournamentCode`) REFERENCES `Tournament` (`tournamentCode`),
  CONSTRAINT `FK_guestTeamCode` FOREIGN KEY (`guestTeamCode`) REFERENCES `Team` (`teamCode`),
  CONSTRAINT `FK_hostTeamCode` FOREIGN KEY (`hostTeamCode`) REFERENCES `Team` (`teamCode`),
  CONSTRAINT `FK_seasonCode` FOREIGN KEY (`seasonCode`) REFERENCES `Season` (`seasonCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'User' table
CREATE TABLE `User` (
  `userId`    BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `userCode`  VARCHAR(10) NOT NULL, 
  `userEmail` VARCHAR(100) NOT NULL,
  `userPassword`  VARCHAR(255) NOT NULL,
  `userName`  VARCHAR(255) NOT NULL,
  `userCountryCode`    VARCHAR(3)    DEFAULT NULL,
  `active` BOOL NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `userCode` (`userCode`),
  UNIQUE KEY `userEmail` (`userEmail`),  
  KEY `FK_userCountryCode` (`userCountryCode`),
  CONSTRAINT `FK_userCountryCode` FOREIGN KEY (`userCountryCode`) REFERENCES `Country` (`countryCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastTeam' table
CREATE TABLE `ForecastTeam` (
  `fTeamId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fTeamCode` VARCHAR(12)   NOT NULL,
  `fTeamName` VARCHAR(255) NOT NULL,
  `fUserCode`  VARCHAR(10) NOT NULL,
  PRIMARY KEY (`fTeamId`),
  UNIQUE KEY `fTeamCode` (`fTeamCode`),
  UNIQUE KEY `fTeamName` (`fTeamName`),
  KEY `FK_fUserCode` (`fUserCode`),
  CONSTRAINT `FK_fUserCode` FOREIGN KEY (`fUserCode`) REFERENCES `User` (`userCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastSeason' table
CREATE TABLE `ForecastSeason` (
  `fSeasonId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fSeasonCode` VARCHAR(9)   NOT NULL,
  `fSeasonName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`fSeasonId`),
  UNIQUE KEY `fSeasonCode` (`fSeasonCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastTournamentType' table
CREATE TABLE `ForecastTournamentType` (
  `Id`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fTypeCode` VARCHAR(2)  NOT NULL,
  `fTypeDescription` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `fTypeCode` (`fTypeCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastTournamentStatus' table
CREATE TABLE `ForecastTournamentStatus` (
  `Id`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fStatusCode` VARCHAR(2)  NOT NULL,
  `fStatusName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `fStatusCode` (`fStatusCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastTournament' table
CREATE TABLE `ForecastTournament` (
  `fTournamentId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fTournamentCode` VARCHAR(20)  NOT NULL,
  `fTournamentName` VARCHAR(255) NOT NULL,
  `fTournamentTypeCode` VARCHAR(2)  NOT NULL,
  `fTournamentStatusCode` VARCHAR(2)  NOT NULL,
  PRIMARY KEY (`fTournamentId`),
  UNIQUE KEY `fTournamentCode` (`fTournamentCode`),
  KEY `FK_fTournamentTypeCode` (`fTournamentTypeCode`),
  KEY `FK_fTournamentStatusCode` (`fTournamentStatusCode`),
  CONSTRAINT `FK_fTournamentStatusCode` FOREIGN KEY (`fTournamentStatusCode`) REFERENCES `ForecastTournamentStatus` (`fStatusCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastTournamentTeams' table
CREATE TABLE `ForecastTournamentTeams` (
  `Id`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fTournamentCode` VARCHAR(20)  NOT NULL,
  `fSeasonCode` VARCHAR(9)   NOT NULL,
  `fTeamCode` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FTT_fTournamentCode` (`fTournamentCode`),
  KEY `FTT_fSeasonCode` (`fSeasonCode`),
  KEY `FTT_fTeamCode` (`fTeamCode`),
  CONSTRAINT `FTT_fSeasonCode` FOREIGN KEY (`fSeasonCode`) REFERENCES `ForecastSeason` (`fSeasonCode`),
  CONSTRAINT `FTT_fTournamentCode` FOREIGN KEY (`fTournamentCode`) REFERENCES `ForecastTournament` (`fTournamentCode`),
  CONSTRAINT `FTT_fTeamCode` FOREIGN KEY (`fTeamCode`) REFERENCES `ForecastTeam` (`fTeamCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastStatus' table
CREATE TABLE `ForecastStatus` (
  `fStatusId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fStatusCode` VARCHAR(2)  NOT NULL,
  `fStatusName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`fStatusId`),
  UNIQUE KEY `fStatusCode` (`fStatusCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastMatchStatus' table
CREATE TABLE `ForecastMatchStatus` (
  `fStatusId`   BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `fStatusCode` VARCHAR(2)  NOT NULL,
  `fStatusName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`fStatusId`),
  UNIQUE KEY `fStatusCode` (`fStatusCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastMatch' table
CREATE TABLE `ForecastMatch` (
  `matchId`     BIGINT(20) NOT NULL AUTO_INCREMENT,
  `matchCode`   VARCHAR(30) NOT NULL,
  `matchStatusCode` VARCHAR(2)  NOT NULL,
  `date`         DATETIME            DEFAULT NULL,
  `fMatchDay`     TINYINT(4) NOT NULL,
  `fSeasonCode`     VARCHAR(9) NOT NULL,
  `fTournamentCode` VARCHAR(20) NOT NULL,
  `fHostTeamCode`  VARCHAR(12) NOT NULL,
  `fGuestTeamCode`   VARCHAR(12) NOT NULL,
  PRIMARY KEY (`matchId`),
  UNIQUE KEY `matchCode` (`matchCode`),
  KEY `FK_fMatchStatusCode` (`matchStatusCode`),
  KEY `FK_fSeasonCode` (`fSeasonCode`),
  KEY `FK_fTournamentCode` (`fTournamentCode`),
  KEY `FK_fHostTeamCode` (`fHostTeamCode`),
  KEY `FK_fGuestTeamCode` (`fGuestTeamCode`),
  CONSTRAINT `FK_fMatchStatusCode` FOREIGN KEY (`matchStatusCode`) REFERENCES `ForecastMatchStatus` (`fStatusCode`),
  CONSTRAINT `FK_fSeasonCode` FOREIGN KEY (`fSeasonCode`) REFERENCES `ForecastSeason` (`fSeasonCode`),
  CONSTRAINT `FK_fTournamentCode` FOREIGN KEY (`fTournamentCode`) REFERENCES `ForecastTournament` (`fTournamentCode`),
  CONSTRAINT `FK_fHostTeamCode` FOREIGN KEY (`fHostTeamCode`) REFERENCES `ForecastTeam` (`fTeamCode`),
  CONSTRAINT `FK_fGuestTeamCode` FOREIGN KEY (`fGuestTeamCode`) REFERENCES `ForecastTeam` (`fTeamCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'Forecast' table
CREATE TABLE `Forecast` (
  `forecastId`     BIGINT(20) NOT NULL AUTO_INCREMENT,
  `forecastCode`   VARCHAR(40)       NOT NULL,
  `forecastTeamCode`   VARCHAR(12)       NOT NULL,
  `forecastStatusCode` VARCHAR(2)  NOT NULL,
  `forecastModified`         DATETIME            DEFAULT NULL,
  `fMatchCode`   VARCHAR(24)         NOT NULL,
  `fResultCode`   VARCHAR(24)         NOT NULL,
  `fGoalsByHost` TINYINT(4)          DEFAULT NULL,
  `fGoalsByGuest`  TINYINT(4)          DEFAULT NULL,
  `fPoints`  TINYINT(2)          DEFAULT NULL,
  PRIMARY KEY (`forecastId`),
  UNIQUE KEY `forecastCode` (`forecastCode`),
  UNIQUE KEY `forecastRecord` (`forecastTeamCode`, `fMatchCode`, `fResultCode`),
  KEY `FK_forecastTeamCode` (`forecastTeamCode`),
  KEY `FK_forecastStatusCode` (`forecastStatusCode`),
  KEY `FK_forecastMatchCode` (`fMatchCode`),
  KEY `FK_forecastResultCode` (`fResultCode`),
  CONSTRAINT `FK_forecastTeamCode` FOREIGN KEY (`forecastTeamCode`) REFERENCES `ForecastTeam` (`fTeamCode`),
  CONSTRAINT `FK_forecastStatusCode` FOREIGN KEY (`forecastStatusCode`) REFERENCES `ForecastStatus` (`fStatusCode`),
  CONSTRAINT `FK_forecastMatchCode` FOREIGN KEY (`fMatchCode`) REFERENCES `ForecastMatch` (`matchCode`),
  CONSTRAINT `FK_forecastResultCode` FOREIGN KEY (`fResultCode`) REFERENCES `Result` (`resultCode`)
)
  DEFAULT CHARSET = utf8;

-- create 'ForecastBacklog' table
CREATE TABLE `ForecastBacklog` (
  `id`     BIGINT(20) NOT NULL AUTO_INCREMENT,
  `fSeasonCode`     VARCHAR(9) NOT NULL,
  `fTournamentCode` VARCHAR(20) NOT NULL,
  `fMatchDay`     TINYINT(4) NOT NULL,
  `resultCode`   VARCHAR(24)         DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `backlogItem` (`fSeasonCode`, `fTournamentCode`, `resultCode`),
  KEY `FK_FB_fSeasonCode` (`fSeasonCode`),
  KEY `FK_FB_fTournamentCode` (`fTournamentCode`),
  KEY `FK_FB_resultCode` (`resultCode`),
  CONSTRAINT `FK_FB_fSeasonCode` FOREIGN KEY (`fSeasonCode`) REFERENCES `ForecastSeason` (`fSeasonCode`),
  CONSTRAINT `FK_FB_fTournamentCode` FOREIGN KEY (`fTournamentCode`) REFERENCES `ForecastTournament` (`fTournamentCode`),
  CONSTRAINT `FK_FB_resultCode` FOREIGN KEY (`resultCode`) REFERENCES `Result` (`resultCode`)
)
  DEFAULT CHARSET = utf8;





