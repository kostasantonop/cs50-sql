/*SOME DUMMY INPUT FOR THE DB*/
INSERT INTO artist (artist_name, country)
VALUES ('Iron Maiden', 'UK'),
	   ('Judas Priest', 'UK'),
       ('Megadeth', 'USA'),
       ('Kreator', 'Germany');

INSERT INTO album (album_title, album_duration, album_date_of_creation, artist_id)
VALUES ('Painkiller', 45.52, '1990-9-14', (SELECT artist_id FROM artist WHERE artist_name = 'Judas Priest')),
	   ('Rust in peace', 40.44, '1990-9-24', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('Countdown to Extinction', 47.26, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('Sejutsu', 81.53, '2021-9-3', (SELECT artist_id FROM artist WHERE artist_name = 'Iron Maiden')),
       ('Pleasure to Kill', 38.42, '1986-11-1', (SELECT artist_id FROM artist WHERE artist_name = 'Kreator'));

INSERT INTO song (song_title, song_duration, song_date_of_creation, artist_id)
VALUES ('Skin o` My Teeth', 3.14, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
	   ('Symphony of Destruction', 4.02, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('Sweating Bullets', 5.03, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('This Was My Life', 3.14, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('Captive Honor', 4.14, '1992-8-14', (SELECT artist_id FROM artist WHERE artist_name = 'Megadeth')),
       ('Pleasure to Kill', 4.11, '1986-11-1', (SELECT artist_id FROM artist WHERE artist_name = 'Kreator')),
       ('Stratego', 4.59, '2021-9-3', (SELECT artist_id FROM artist WHERE artist_name = 'Iron Maiden')),
       ('Senjutsu', 8.20, '2021-9-3', (SELECT artist_id FROM artist WHERE artist_name = 'Iron Maiden')),
       ('Painkiller', 6.06, '1990-9-4', (SELECT artist_id FROM artist WHERE artist_name = 'Judas Priest')),
       ('Hell Patrol', 3.35, '1990-9-4', (SELECT artist_id FROM artist WHERE artist_name = 'Judas Priest'));

INSERT INTO album_songs (song_id, album_id, track_number)
VALUES ((SELECT song_id FROM song WHERE song_title = 'Skin o` My Teeth'), (SELECT album_id FROM album WHERE album_title = 'Countdown to Extinction'), 1),
	   ((SELECT song_id FROM song WHERE song_title = 'Symphony of Destruction'), (SELECT album_id FROM album WHERE album_title = 'Countdown to Extinction'), 2),
       ((SELECT song_id FROM song WHERE song_title = 'Sweating Bullets'), (SELECT album_id FROM album WHERE album_title = 'Countdown to Extinction'), 5),
       ((SELECT song_id FROM song WHERE song_title = 'This Was My Life'), (SELECT album_id FROM album WHERE album_title = 'Countdown to Extinction'), 6),
       ((SELECT song_id FROM song WHERE song_title = 'Captive Honor'), (SELECT album_id FROM album WHERE album_title = 'Countdown to Extinction'), 10),
       ((SELECT song_id FROM song WHERE song_title = 'Stratego'), (SELECT album_id FROM album WHERE album_title = 'Sejutsu'), 2),
       ((SELECT song_id FROM song WHERE song_title = 'Senjutsu'), (SELECT album_id FROM album WHERE album_title = 'Sejutsu'), 1),
       ((SELECT song_id FROM song WHERE song_title = 'Painkiller'), (SELECT album_id FROM album WHERE album_title = 'Painkiller'), 1),
       ((SELECT song_id FROM song WHERE song_title = 'Hell Patrol'), (SELECT album_id FROM album WHERE album_title = 'Painkiller'), 2),
       ((SELECT song_id FROM song WHERE song_title = 'Pleasure to Kill'), (SELECT album_id FROM album WHERE album_title = 'Pleasure to Kill'), 4);


INSERT INTO user (username, password, user_type, email, charge)
VALUES ('kostas123', 'zazapapa', 'individual', 'kwstas_adonoplos@hotmail.com', 7.99),
	   ('lanthimoskop', 'littlepoorthings', 'family', 'lanthimiato@gmail.com', 12.99),
       ('maria3', 'minikini', 'student', 'its@maria.com', 3.99);

INSERT INTO playlist (playlist_title, playlist_description, user_id)
VALUES ('Random playlist', 'A random playlist with some random songs i found', (SELECT user_id FROM user WHERE username = 'kostas123')),
	   ('Megadeth Playlist', 'My favorite Megadeth songs', (SELECT user_id FROM user WHERE username = 'kostas123')),
       ('I could not find vivaldi', 'I could not find vivaldi so i did this instead', (SELECT user_id FROM user WHERE username = 'maria3')),
       ('Judas Priest', 'Awesome Judas Priest Playlist', (SELECT user_id FROM user WHERE username = 'lanthimoskop'));

INSERT INTO playlist_songs (playlist_id, song_id)
VALUES  ((SELECT playlist.playlist_id FROM playlist	WHERE playlist_title = 'Random playlist'), (SELECT song_id FROM song WHERE song_title = 'Skin o` My Teeth')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Random playlist'), (SELECT song_id FROM song WHERE song_title = 'Painkiller')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Random playlist'), (SELECT song_id FROM song WHERE song_title = 'Pleasure to Kill')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Megadeth playlist'), (SELECT song_id FROM song WHERE song_title = 'Captive Honor')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Megadeth playlist'), (SELECT song_id FROM song WHERE song_title = 'Sweating Bullets')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Megadeth playlist'), (SELECT song_id FROM song WHERE song_title = 'This Was My Life')),
		((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Megadeth playlist'), (SELECT song_id FROM song WHERE song_title = 'Symphony of Destruction')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Judas Priest'), (SELECT song_id FROM song WHERE song_title = 'Painkiller')),
        ((SELECT playlist.playlist_id FROM playlist WHERE playlist_title = 'Judas Priest'), (SELECT song_id FROM song WHERE song_title = 'Hell Patrol'));

INSERT INTO likes (user_id, song_id)
VALUES ((SELECT user_id FROM user WHERE username = 'kostas123'), (SELECT song_id FROM song WHERE song_title = 'Pleasure to Kill')),
	   ((SELECT user_id FROM user WHERE username = 'kostas123'), (SELECT song_id FROM song WHERE song_title = 'Sweating Bullets')),
       ((SELECT user_id FROM user WHERE username = 'maria3'), (SELECT song_id FROM song WHERE song_title = 'Painkiller')),
	   ((SELECT user_id FROM user WHERE username = 'lanthimoskop'), (SELECT song_id FROM song WHERE song_title = 'Stratego')),
       ((SELECT user_id FROM user WHERE username = 'lanthimoskop'), (SELECT song_id FROM song WHERE song_title = 'Sweating Bullets')),
       ((SELECT user_id FROM user WHERE username = 'maria3'), (SELECT song_id FROM song WHERE song_title = 'Sweating Bullets')),
       ((SELECT user_id FROM user WHERE username = 'maria3'), (SELECT song_id FROM song WHERE song_title = 'Pleasure to Kill'));

INSERT INTO play_history(user_id, song_id)
VALUES (1,2),
	   (1,3),
       (2,3),
       (2,1),
       (1,5),
       (1,4),
       (3,2);

/*EXPECTED QUERIES
NOTE: No LIMIT has been implemented within the VIEWS. Thats intentional so as to better monitor the results of each query*/

/*This is a stored procedure that checks if the student (through matching both username and email) existed
in the system in the past.
If he did then he is restored, if he didn't then he is inserted as usual.*/
CALL SoftInsert('cs50student', 'cs50', 'student', 'student@mail');

/*Using SoftDelete('cs50student') we can soft delete a user depending on his username (which is unique for every user)*/

/*Through this view we can see only the users that are not deleted*/
SELECT * FROM spotify.users_not_deleted;

/*Through this procedure we can quickly and easily add a liked song in the list of liked songs
by only using its title and the username of the user that likes it
LIMITATION: If 2 songs have the same title this will not work properly*/
CALL EasyLike('cs50student', 'Senjutsu');

/*Using CALL EasyDislike('cs50student', 'Senjutsu') we can dislike an already liked song*/

/*With this VIEW we can see all likes of a particular user or all users that have liked a particular song
,depending on what the WHERE clause is*/
SELECT * FROM spotify.user_likes
WHERE song_title = 'Pleasure to Kill';

/*--Querying for the most liked song by users, by adding a WHERE clause we can search
for the most liked song of an album or an artist*/
SELECT * FROM spotify.most_liked_songs
WHERE artist_name = 'Iron Maiden';

/*--As above , querying for the most liked album (album that contains the most liked songs) by users*
This is a view based on a view*/
SELECT * FROM spotify.most_liked_albums
WHERE artist_name = 'Iron Maiden';

/*With this procedure we take note whenever a user replays a song and update its last played time
and the numbers that it has been played (We can see these things in the history VIEW)*/
CALL replays('cs50student', 'Senjutsu');

/*--Quering for what have all users listened to chronologically from the most recent listen to the oldest.
By adding a WHERE clause we can search for the listening history of a single user*/
SELECT * FROM spotify.history
WHERE username = 'kostas123';

/*--Querying for all the albums of an artist.
By adding a WHERE clause we can search for a date that some albums where created or for the albums
of a single artist*/
SELECT * FROM spotify.albums_of_artists
WHERE album_date_of_creation LIKE '2021%';

/*Similarly we can see all songs included in every album*/
SELECT * FROM spotify.songs_of_albums
WHERE album_title = 'Countdown to Extinction';

/*We can create a playlist by using a simple insert
Every playlist is going to have a title a description and a date of creation.
Also it is going to be related (created) to a user.*/
INSERT INTO playlist (playlist_title, playlist_description, user_id)
VALUES ('CS50 Playlist', 'An example for the queries.sql', (SELECT user_id FROM user WHERE username = 'cs50student'));

/*We can see all the playlists that users have created by using the following VIEW
By using a WHERE clause we can see the playlists of a particular user.*/
SELECT * FROM spotify.user_playlists
WHERE  username = 'cs50student';

/*With this procedure we can easily add a song into a playlist simple by using
the name of the playlist and the song*/
CALL EasyAddPlaylistSong('CS50 Playlist', 'Senjutsu');

/*By using CALL EasyRemovePlaylistSong('CS50 Playlist', 'Senjutsu'); we can remove a song from a playlist*/

/*--By using this VIEW we can find the most liked playlists (according to the cumulative likes of all songs included within each)
By using a WHERE clause we can find */
SELECT * FROM spotify.most_liked_playlists
WHERE playlist_title = 'CS50 Playlist';

/*With this VIEW we can explore the inner content of a playlist specified with a WHERE clause*/
SELECT * FROM spotify.songs_of_playlists
WHERE playlist_title = 'CS50 Playlist';

/*With the following 3 VIEWS we can see the songs with the most replays as well as the albums and the playlists that have the most cumulative replays
(meaning the replays of the songs they include)*/
SELECT * FROM spotify.most_replayed_songs;
SELECT * FROM spotify.most_replayed_albums;
SELECT * FROM spotify.most_replayed_playlists;

/* Aside from the above stored procedures and view queries we are going to use standart INSERT,UPDATE,DELETE queries to add/remove artists,
albums,songs etc.*/
