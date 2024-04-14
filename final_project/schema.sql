DROP DATABASE IF EXISTS spotify;
CREATE DATABASE IF NOT EXISTS spotify;

USE spotify;

/*We assume we cannot INSERT a playlist with the same name to a playlist that already exists
SEE LIMIATIONS DESIGN.md*/

/*Most SELECT results could be stored INTO a variable, but it is not dont on purpose so as to better practice the writing of queries
There have been some INSERTS into the DB to better test the various tables and procedures and views*/

/* We are using mainly the following procedures :
SoftDelete (IN in_username VARCHAR(50)) - to soft-delete users
SoftInsert(IN in_username VARCHAR(50),IN in_password VARCHAR(50),IN in_user_type VARCHAR(50), IN in_email VARCHAR(50) - to insert users
replays (IN in_username VARCHAR(50), IN in_song_title VARCHAR(50)) - to replay a song
EasyLike(IN in_username VARCHAR(50), IN in_song_title VARCHAR(50)) - to like a song without the use of IDs
EasyDislike(IN in_username VARCHAR(50), IN in_song_title VARCHAR(50)) - to dislike a song without the use of IDs
EasyAddPlaylistSong(IN in_playlist_title VARCHAR(50), IN in_song_title VARCHAR(50)) - to add a song into a playlist without the use of IDs
EasyRemovePlaylistSong(IN in_playlist_title VARCHAR(50), IN in_song_title VARCHAR(50)) - to remove a song from a playlist without the use of IDs
*/

/*TABLES*/
CREATE TABLE IF NOT EXISTS user (
	user_id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    user_type ENUM('individual', 'student', 'family') NOT NULL DEFAULT 'individual',
    email VARCHAR(50) NOT NULL UNIQUE,
    charge DECIMAL(5, 2)  DEFAULT 7.99,
    user_date_of_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    profile_picture BLOB,
    deleted TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS user_changes(
	user_change_id INT NOT NULL AUTO_INCREMENT,
    user_change_type VARCHAR(20) NOT NULL,
    change_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    old_value VARCHAR(50) DEFAULT '-',
    new_value VARCHAR(50) DEFAULT '-',
    PRIMARY KEY(user_change_id)
);

CREATE TABLE IF NOT EXISTS playlist(
	playlist_id INT NOT NULL AUTO_INCREMENT,
    playlist_title VARCHAR(50) NOT NULL,
    playlist_description TEXT,
    playlist_icon BLOB,
    user_id INT NOT NULL,
    playlist_date_of_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY(playlist_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE IF NOT EXISTS artist(
	artist_id INT NOT NULL AUTO_INCREMENT,
    artist_name VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    PRIMARY KEY (artist_id)
);

CREATE TABLE IF NOT EXISTS song(
	song_id INT NOT NULL AUTO_INCREMENT,
    song_title VARCHAR(50) NOT NULL,
    song_duration DECIMAL (5, 2) NOT NULL,
    song_date_of_creation DATE NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (song_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

CREATE TABLE IF NOT EXISTS playlist_songs(
	playlist_id INT NOT NULL,
    song_id INT NOT NULL,
    song_date_added DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (playlist_id, song_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id)
);

CREATE TABLE IF NOT EXISTS likes (
	user_id INT NOT NULL,
    song_id INT NOT NULL,
    date_of_like DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id)
);

CREATE TABLE IF NOT EXISTS play_history (
	user_id INT NOT NULL,
    song_id INT NOT NULL,
    played_last DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    times_played SMALLINT NOT NULL DEFAULT 1 ,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id)
);

CREATE TABLE IF NOT EXISTS album(
	album_id INT NOT NULL AUTO_INCREMENT,
    album_title VARCHAR(50) NOT NULL,
    album_duration DECIMAL(5, 2) NOT NULL,
    album_date_of_creation DATE NOT NULL,
    album_cover BLOB,
    artist_id INT,
    PRIMARY KEY (album_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

CREATE TABLE IF NOT EXISTS album_songs(
	album_id INT NOT NULL,
    song_id INT NOT NULL,
    track_number SMALLINT,
    PRIMARY KEY (album_id, song_id),
    FOREIGN KEY (album_id) REFERENCES album(album_id),
    FOREIGN KEY (song_id) REFERENCES song(song_id)
);

/*TRIGGERS*/

/*Inserts into the user_changes table after a fresh insert*/
DELIMITER //
CREATE TRIGGER user_inserted AFTER INSERT ON user
FOR EACH ROW
BEGIN
	INSERT INTO user_changes (user_change_type, user_id, new_value)
    VALUES ('New user',  NEW.user_id, NEW.username);
END//
DELIMITER ;

/*Inserts into the user_changes table after an update*/
DELIMITER //
CREATE TRIGGER user_updated AFTER UPDATE ON user
FOR EACH ROW
BEGIN
	IF(NEW.deleted = 1) THEN
		INSERT INTO user_changes (user_change_type, user_id, old_value)
		VALUES ('Deleted user',  NEW.user_id, NEW.username);
	ELSEIF(NEW.username != OLD.username) THEN
		INSERT INTO user_changes (user_change_type, user_id , old_value, new_value)
		VALUES ('User username update',  NEW.user_id, OLD.username, NEW.username);
	ELSEIF(NEW.password != OLD.password) THEN
		INSERT INTO user_changes (user_change_type, user_id, old_value, new_value)
		VALUES ('User password update',  NEW.user_id, OLD.password, NEW.password);
	ELSEIF(NEW.email != OLD.email) THEN
		INSERT INTO user_changes (user_change_type, user_id, old_value, new_value)
		VALUES ('User email update',  NEW.user_id, OLD.email, NEW.email);
	ELSEIF(NEW.user_type != OLD.user_type) THEN
		INSERT INTO user_changes (user_change_type, user_id, old_value, new_value)
		VALUES ('User type update',  NEW.user_id, OLD.user_type, NEW.user_type);
	ELSEIF(NEW.deleted = 0) THEN
		INSERT INTO user_changes (user_change_type, user_id, new_value)
		VALUES ('Returned user',  NEW.user_id, NEW.username);
	END IF;
END//
DELIMITER ;

/*VIEWS*/

/* Songs ordered depending on the amount of likes each song has from multiple users.
If a user is soft-deleted, his likes are going to be deleted too.*/
CREATE VIEW most_liked_songs AS
SELECT COUNT(*) AS Number_of_likes, song.song_title, album.album_title, artist.artist_name , song.song_date_of_creation FROM likes
	JOIN song ON likes.song_id = song.song_id
	JOIN album_songs ON album_songs.song_id = song.song_id
	JOIN album  ON album_songs.album_id = album.album_id
	JOIN artist ON song.artist_id = artist.artist_id
	GROUP BY song.song_id, album.album_id
	ORDER BY Number_of_likes DESC;

/*Playlists ordered depending on the cumulative likes of all songs contained in them.*/
CREATE VIEW most_liked_playlists AS
	SELECT COUNT(*) AS Number_of_likes, playlist.playlist_title, username FROM likes
	JOIN playlist_songs ON playlist_songs.song_id = likes.song_id
	JOIN playlist ON playlist_songs.playlist_id = playlist.playlist_id
	JOIN user ON playlist.user_id = user.user_id
    WHERE playlist.deleted = 0
	GROUP BY playlist.playlist_title, user.username
    ORDER BY Number_of_likes DESC;

CREATE VIEW most_liked_albums AS
	SELECT SUM(Number_of_likes) AS Number_of_Likes, album_title, artist_name FROM most_liked_songs
    GROUP BY album_title, artist_name
	ORDER BY Number_of_likes DESC, album_title;


/*Albums and the artists that created them*/
CREATE VIEW albums_of_artists AS
	SELECT artist.artist_name, album.album_title, album.album_duration, album.album_date_of_creation FROM album
	JOIN artist ON album.artist_id = artist.artist_id
	ORDER BY artist.artist_name, album.album_title;

/*Songs and the albums they are included in*/
CREATE VIEW songs_of_albums AS
	SELECT song.song_title, song.song_duration, artist.artist_name,  album.album_title, album.album_duration FROM song
	JOIN album_songs ON song.song_id = album_songs.song_id
	JOIN album ON album_songs.album_id = album.album_id
    JOIN artist ON song.artist_id = artist.artist_id
	ORDER BY album.album_title, song.song_title;

/*Playlists and the users that created them, the duration of the playlist is calculated on the fly*/
CREATE VIEW user_playlists AS
	SELECT user.username, playlist_title,COALESCE(SUM(song.song_duration), 0) AS playlist_duration, playlist_description, playlist_date_of_creation FROM playlist
	JOIN user ON playlist.user_id = user.user_id
    LEFT JOIN playlist_songs ON playlist.playlist_id = playlist_songs.playlist_id
    LEFT JOIN song ON playlist_songs.song_id = song.song_id
    WHERE playlist.deleted = 0
    GROUP BY playlist.playlist_id
    ORDER BY user.username, playlist.playlist_title;

/*Songs that are included in the playlists*/
CREATE VIEW songs_of_playlists AS
	SELECT playlist.playlist_title, user.username, song.song_title , song.song_duration, artist.artist_name, playlist_songs.song_date_added FROM playlist_songs
	JOIN song ON playlist_songs.song_id = song.song_id
	JOIN playlist ON playlist.playlist_id = playlist_songs.playlist_id
	JOIN artist ON song.artist_id = artist.artist_id
    JOIN user ON user.user_id = playlist.user_id
    WHERE playlist.deleted = 0
    ORDER BY user.username, playlist.playlist_title, song.song_title;

/*User usernames and the songs they like*/
CREATE VIEW user_likes AS
SELECT user.username, song.song_title, likes.date_of_like FROM user
JOIN likes ON user.user_id = likes.user_id
JOIN song ON likes.song_id = song.song_id
ORDER BY date_of_like DESC;

/* A view that shows non deleted users*/
CREATE VIEW users_not_deleted AS
SELECT * FROM user
WHERE deleted = 0;

/*A better play history table*/
CREATE VIEW history AS
SELECT user.username, song.song_title,  album.album_title, play_history.played_last, play_history.times_played FROM play_history
JOIN user ON play_history.user_id = user.user_id
JOIN song ON play_history.song_id = song.song_id
JOIN album_songs ON song.song_id = album_songs.song_id
JOIN album ON album_songs.album_id = album.album_id
WHERE user.deleted = 0
ORDER BY played_last DESC;

/*Most replayed songs based on the history view*/
CREATE VIEW most_replayed_songs AS
SELECT SUM(times_played) AS times_played, song_title FROM history
GROUP BY song_title
ORDER BY times_played DESC;

/*Most replayed albums based on the history view*/
CREATE VIEW most_replayed_albums AS
SELECT SUM(times_played) AS times_played, album_title FROM history
GROUP BY album_title
ORDER BY times_played DESC;

/*View similar to most_liked_playlists that shows how many cumulative times the songs of a playlist have been replayed*/
CREATE VIEW most_replayed_playlists AS
SELECT SUM(times_played) AS times_played, playlist.playlist_title FROM spotify.play_history
JOIN playlist_songs ON playlist_songs.song_id = play_history.song_id
JOIN playlist ON playlist_songs.playlist_id = playlist.playlist_id
JOIN user ON playlist.user_id = user.user_id
GROUP BY playlist.playlist_id
ORDER BY times_played DESC;

/*PROCEDURES*/

/*The user is soft deleted as well as his playlists,
but his favorite songs(likes) are permanently deleted and if he ever comes back, he needs to start all over*/

/*The user is soft deleted as well as his playlists,
but his favorite songs(likes) are permanently deleted and if he ever comes back, he needs to start all over*/
DELIMITER //
CREATE PROCEDURE SoftDelete (IN in_username VARCHAR(50))
BEGIN
	DECLARE in_user_id INT ;
    SELECT user_id INTO in_user_id  FROM user WHERE username = in_username;
    IF ( (SELECT deleted FROM user WHERE user_id = in_user_id) = 0) THEN
		DELETE FROM likes WHERE user_id = in_user_id;
		UPDATE user SET deleted = 1 WHERE user_id = in_user_id;
		UPDATE playlist SET deleted = 1 WHERE user_id = in_user_id;
	END IF;
END//
DELIMITER ;


/*The user is restored only if the new user account created has exactly the same username and email
If only the username matches then the new user is going to have to find a new one, if only the email matches, the user is going to have to use another one
Depending on the user_type, the charge is changed*/
DELIMITER $$
CREATE PROCEDURE SoftInsert(IN in_username VARCHAR(50),IN in_password VARCHAR(50),IN in_user_type VARCHAR(50), IN in_email VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM user WHERE username = in_username AND email = in_email AND deleted = 1) > 0) THEN
		UPDATE user	SET deleted = 0 WHERE username = in_username;
        UPDATE playlist SET deleted = 0 WHERE user_id = (SELECT user_id FROM user WHERE username = in_username AND email = in_email);
	ELSE
		IF (in_user_type = 'student') THEN
			INSERT INTO user(username, password, user_type, email, charge) VALUES(in_username,in_password,in_user_type, in_email, 3.99);
		ELSEIF (in_user_type = 'individual') THEN
			INSERT INTO user(username, password, user_type, email, charge) VALUES(in_username,in_password,in_user_type, in_email, DEFAULT);
		ELSEIF (in_user_type = 'family') THEN
			INSERT INTO user(username, password, user_type, email, charge) VALUES(in_username,in_password,in_user_type, in_email, 12.99);
		END IF;
	END IF;
END$$
DELIMITER ;

/*Stored procedure that increases the times_played counter of a song in history VIEW if its already in the play_history table.
Otherwise it just adds a new song into the play_history if both the user and the song exists*/
DELIMITER //
CREATE PROCEDURE replays (IN in_username VARCHAR(50), IN in_song_title VARCHAR(50))
BEGIN
	IF((SELECT COUNT(*) FROM user WHERE deleted = 0 AND username = in_username) > 0)	THEN
		IF((SELECT COUNT(*) FROM play_history
			JOIN user ON play_history.user_id = user.user_id
			JOIN song ON play_history.song_id = song.song_id
			WHERE user.username = in_username AND song.song_title = in_song_title) > 0) THEN
				UPDATE play_history SET play_history.times_played = play_history.times_played + 1
                WHERE user_id = (SELECT user_id FROM user WHERE username = in_username) AND song_id = (SELECT song_id FROM song WHERE song_title = in_song_title);
                UPDATE play_history SET play_history.played_last = DEFAULT
                WHERE user_id = (SELECT user_id FROM user WHERE username = in_username) AND song_id = (SELECT song_id FROM song WHERE song_title = in_song_title);
		ELSE
			INSERT INTO play_history (user_id, song_id)
			VALUES ((SELECT user_id FROM user WHERE username = in_username),(SELECT song_id FROM song WHERE song_title = in_song_title));
		END IF;
	END IF;
END//
DELIMITER ;

/* 2 easy procedures so that we can insert and remove from the likes table without using the id of users and songs */
DELIMITER //
CREATE PROCEDURE EasyLike(IN in_username VARCHAR(50), IN in_song_title VARCHAR(50))
BEGIN
	IF((SELECT COUNT(*) FROM user WHERE username = in_username AND deleted = 0) > 0) THEN
		INSERT INTO likes (user_id, song_id)
		VALUES ((SELECT user_id FROM user WHERE username = in_username), (SELECT song_id FROM song WHERE song_title = in_song_title));
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EasyDislike(IN in_username VARCHAR(50), IN in_song_title VARCHAR(50))
BEGIN
	IF((SELECT COUNT(*) FROM user WHERE username = in_username AND deleted = 0) > 0) THEN
		DELETE FROM likes
		WHERE user_id = (SELECT user_id FROM user WHERE username = in_username) AND song_id = (SELECT song_id FROM song WHERE song_title = in_song_title);
	END IF;
END//
DELIMITER ;

/*2 easy procedures so that we can insert and remove from each playlist without using the id of the playlist and the songs
One caviat is that all users can add and remove songs from any playlist
Playlists from soft deleted users are not visible*/
DELIMITER //
CREATE PROCEDURE EasyAddPlaylistSong(IN in_playlist_title VARCHAR(50), IN in_song_title VARCHAR(50))
BEGIN
	IF((SELECT COUNT(*) FROM playlist WHERE playlist_title = in_playlist_title AND deleted = 0) > 0) THEN
		INSERT INTO playlist_songs (playlist_id, song_id)
        VALUES ((SELECT playlist_id FROM playlist WHERE playlist.playlist_title = in_playlist_title), (SELECT song_id FROM song WHERE song.song_title = in_song_title));
	END IF ;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EasyRemovePlaylistSong(IN in_playlist_title VARCHAR(50), IN in_song_title VARCHAR(50))
BEGIN
	IF((SELECT COUNT(*) FROM playlist WHERE playlist_title = in_playlist_title AND deleted = 0) > 0) THEN
		DELETE FROM playlist_songs
        WHERE playlist_id = (SELECT playlist_id FROM user WHERE playlist_title = in_playlist_title) AND song_id = (SELECT song_id FROM song WHERE song_title = in_song_title);
	END IF ;
END//
DELIMITER ;



/*INDEXES*/

CREATE INDEX idx_artist ON artist(artist_name);
CREATE INDEX idx_album ON album(artist_id, album_title);
CREATE INDEX idx_username ON user(username);
