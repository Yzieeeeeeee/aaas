import 'package:flutter/material.dart';
import 'package:musicplayer/services/album_tracks.dart';
import 'package:musicplayer/views/get_several_album_func.dart';
import 'models/get_several_albums.dart' hide Image;

class AlbumsPage extends StatefulWidget {
  final String accessToken;
  const AlbumsPage({super.key, required this.accessToken});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  late Future<Welcome> _futureAlbums;

  @override
  void initState() {
    super.initState();
    _futureAlbums = fetchUserAlbums(widget.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Spotify Albums"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Welcome>(
        future: _futureAlbums,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.redAccent)),
            );
          } else if (!snapshot.hasData || snapshot.data!.albums.isEmpty) {
            return const Center(
              child: Text("No albums found", style: TextStyle(color: Colors.white)),
            );
          }

          final albums = snapshot.data!.albums;

          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: album.images.isNotEmpty
                      ? Image.network(album.images[0].url, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.album, color: Colors.white70, size: 50),
                  title: Text(album.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "Tracks: ${album.totalTracks} • Release: ${album.releaseDate}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    // Navigate to album details / track list
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumTracksPage(album: album),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
