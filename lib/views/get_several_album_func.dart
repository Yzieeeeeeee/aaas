import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/get_several_albums.dart';

Future<Welcome> fetchUserAlbums(String accessToken) async {
  final response = await http.get(
    Uri.parse("https://api.spotify.com/v1/me/albums?limit=20"),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return Welcome.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load albums: ${response.statusCode}");
  }
}
