use TEST;


CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
	Age int,
);

INSERT INTO Artists (Name, Age) VALUES ('Eminem', 41), ('The Weeknd', 35);

CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    ReleaseDate Date,
);

INSERT INTO Albums (Title, ReleaseDate) VALUES ('Album1', '2009-11-12'), ('Album1', '2011-12-1');

CREATE TABLE Songs (
    SongID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    DurationInSeconds INT,
    AlbumID INT FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID)
);

INSERT INTO Songs (Title, DurationInSeconds, AlbumID) VALUES ('Without Me', 60 * 3, 1), ('Diamond', 60 * 4, 2);

CREATE TABLE ArtistAlbum (
    ArtistID INT,
    AlbumID INT,
    PRIMARY KEY (ArtistID, AlbumID),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID)
);

INSERT INTO ArtistAlbum (ArtistID, AlbumID) VALUES (1, 1), (2, 2);

CREATE TABLE SongArtist (
    SongID INT,
    ArtistID INT,
    PRIMARY KEY (SongID, ArtistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
);

INSERT INTO SongArtist (SongID, ArtistID) VALUES (1, 1), (2, 2);

--task 1
CREATE VIEW SongView AS
SELECT
    S.SongID,
    S.Title AS SongTitle,
    A.Title AS AlbumName
FROM Songs	AS S

JOIN Albums AS A 

ON S.AlbumID = A.AlbumID;

SELECT * FROM SongView
---------------


--task 2
INSERT Artists (Name, Age) VALUES ('Somebody', 50)
UPDATE Artists SET Name = 'Somebody2' WHERE Name = 'Somebody'
SELECT * FROM Artists
DELETE FROM Artists WHERE ArtistID = 3

----------

--task 3

CREATE VIEW AlbumSongCount AS
SELECT
    A.AlbumID,
    A.Title AS 'AlbumName',
    COUNT(S.SongID) AS 'SongCount'
FROM Albums  AS A
LEFT JOIN 
Songs AS S ON 
A.AlbumID = S.AlbumID
GROUP BY A.AlbumID, A.Title;


SELECT * FROM AlbumSongCount
----

-- task 4

CREATE PROCEDURE GetMusicByDuration
    @DurationInSeconds INT
AS
BEGIN

    SELECT
        S.SongID,
        S.Title AS SongTitle,
        S.DurationInSeconds,
        A.Title AS AlbumName
    FROM Songs S
    INNER JOIN Albums A ON S.AlbumID = A.AlbumID
    WHERE S.DurationInSeconds > @DurationInSeconds;
END;

EXEC GetMusicByDuration 180
-----


-- task 5

CREATE PROCEDURE GetAlbumsByReleaseDate
    @ReleaseDate DATE
AS
BEGIN
    SELECT
        AlbumID,
        Title AS AlbumName,
        ReleaseDate
    FROM Albums
    WHERE ReleaseDate > @ReleaseDate;
END;

EXEC GetAlbumsByReleaseDate '2009-12-12'
---------------