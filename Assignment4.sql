-- QUERY 1

SELECT DISTINCT customers.LastName, customers.Email 
FROM customers, invoices
WHERE customers.CustomerId = invoices.CustomerId;

-- QUERY 2

SELECT DISTINCT albums.Title, artists.Name 
FROM albums, artists 
WHERE albums.ArtistId = artists.ArtistId;

-- QUERY 3

SELECT customers.State, COUNT(CustomerId) NumCustomers 
FROM customers 
WHERE customers.State is NOT NULL 
GROUP BY customers.State
ORDER BY customers.State;

-- QUERY 4

SELECT customers.State 
FROM customers
WHERE customers.State is NOT NULL
GROUP BY customers.State
HAVING COUNT(CustomerId) > 10;

-- QUERY 5

SELECT DISTINCT artists.Name 
FROM albums, artists 
WHERE artists.ArtistId = albums.ArtistId 
AND albums.Title LIKE "%symphony%";

-- QUERY 6 (if considered to be OR)

SELECT DISTINCT artists.name 
FROM artists, albums, tracks, playlists, playlist_track, media_types 
WHERE artists.ArtistId = albums.ArtistId 
AND albums.AlbumId = tracks.AlbumId 
AND tracks.TrackId = playlist_track.TrackId 
AND playlists.PlaylistId = playlist_track.PlaylistId
AND tracks.MediaTypeId = media_types.MediaTypeId
AND playlists.Name IN ('Grunge','Brazilian Music')
AND media_types.Name LIKE "%MPEG%";

-- QUERY 7

SELECT COUNT(artistid) Count
FROM (select artists.artistid from artists, albums, tracks, media_types
WHERE artists.ArtistId = albums.artistid
AND albums.albumid = tracks.AlbumId
and tracks.mediatypeid = media_types.MediaTypeId
And media_types.name LIKE "%MPEG%"
GROUP BY artists.ArtistId
HAVING COUNT(tracks.TrackId) > 9);

-- QUERY 8

select playlists.PlaylistId, playlists.Name, ROUND(CAST( CAST(SUM(tracks.Milliseconds) as double)/3600000 as double),2) AS LENGTH
from tracks, playlist_track, playlists
where tracks.TrackId = playlist_track.TrackId
and playlists.playlistid = playlist_track.PlaylistId
group by playlists.PlaylistId
having LENGTH > 2

-- QUERY 6 (if considered to be AND)

SELECT DISTINCT artists.name 
FROM artists, albums, tracks, playlists, playlist_track, media_types 
WHERE artists.ArtistId = albums.ArtistId 
AND albums.AlbumId = tracks.AlbumId 
AND tracks.TrackId = playlist_track.TrackId 
AND playlists.PlaylistId = playlist_track.PlaylistId
AND tracks.MediaTypeId = media_types.MediaTypeId
AND playlists.Name = 'Grunge' AND playlists.Name='Brazilian Music'
AND media_types.Name LIKE "%MPEG%";
