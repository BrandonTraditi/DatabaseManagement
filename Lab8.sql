-- --------------------------------------------------------------------------------------------------------
-- Brandon Traditi
-- 11-13-2017
-- Lab 8
-- --------------------------------------------------------------------------------------------------------

-- CHECKS IF TABLES EXISTS AND DROPS THEM

DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS MovieCast;
DROP TABLE IF EXISTS People;


-- ACTORS TABLE
CREATE TABLE Actors (
  PID char(5) NOT NULL references People(PID),
  DOB date,
  HairColor text,
  EyeColor text,
  HeightIN numeric(5,2),
  WeightLBS numeric(5,2),
  Favorite_Color text,
  SAG_AnniversaryDate date,
  PRIMARY KEY (PID)
 );
  
 -- MOVIES TABLE
CREATE TABLE Movies ( 
  Name text,
  Year_Released int,
  MPAA int NOT NULL,
  Domestic_BoxOfficeSalesUSD text,
  Foreign_BoxOfficeSalesUSD text,
  DVD_BluRay_SalesUSD text,
  PRIMARY KEY (MPAA)
);

-- DIRECTORS TABLE
CREATE TABLE Directors (
  PID char(5) NOT NULL references People(PID),
  FilmSchool_Attended text,
  DG_AnniversaryDate text,
  Favorite_LensMaker text,
  PRIMARY KEY (PID)
);


-- MOVIECAST TABLE
CREATE TABLE MovieCast (
  PID char(5) NOT NULL references People(PID),
  MovieRole text NOT NULL,
  MPAA int references Movies(MPAA),
  PRIMARY KEY (PID, MovieRole)
);

-- PEOPLE TABLE
CREATE TABLE People (
  PID char(5) NOT NULL,
  Name text NOT NULL,
  Address text,
  SpouseName text,
  PRIMARY KEY (PID)
);


-- 4 --
SELECT people.name
FROM people INNER JOIN moviecast ON people.pid = moviecast.pid
WHERE Movierole = 'Director'
AND moviecast.mpaa IN ( SELECT moviecast.mpaa
                        FROM moviecast INNER JOIN people ON people.pid = moviecast.pid
                        WHERE people.name = 'Sean Connery' ) ; 