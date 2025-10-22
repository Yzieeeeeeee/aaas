import 'package:flutter/material.dart';

import '../models/get_several_albums.dart';

class AlbumTracksPage extends StatelessWidget {
  final Album album;
  const AlbumTracksPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: album.tracks.items.length,
        itemBuilder: (context, index) {
          final track = album.tracks.items[index];
          return ListTile(
            leading: Text("${track.trackNumber}", style: const TextStyle(color: Colors.white70)),
            title: Text(track.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              track.artists.map((a) => a.name ?? "").join(", "),
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text("${(track.durationMs/1000/60).floor()}:${((track.durationMs/1000)%60).toString().padLeft(2,'0')}",
                style: const TextStyle(color: Colors.white70)),
            onTap: () {
              // Optional: Play previewUrl using audio player
            },
          );
        },
      ),
    );
  }
}
