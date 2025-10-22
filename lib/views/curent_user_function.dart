import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/current_user.dart';

class SpotifyProfilePage extends StatefulWidget {
  final String token;

  const SpotifyProfilePage({super.key, required this.token});

  @override
  State<SpotifyProfilePage> createState() => _SpotifyProfilePageState();
}

class _SpotifyProfilePageState extends State<SpotifyProfilePage> {
  late Future<Welcome> _futureProfile;

  Future<Welcome> fetchSpotifyProfile() async {
    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/me"),
      headers: {
        "Authorization": "Bearer ${widget.token}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return Welcome.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception("Invalid or expired token. Please log in again.");
    } else {
      throw Exception("Failed to load profile: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProfile = fetchSpotifyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Spotify Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Welcome>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No profile data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (user.images.isNotEmpty)
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.images[0]["url"]),
                    )
                  else
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[800]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoBox("Country", user.country),
                      _infoBox("Followers", user.followers.total.toString()),
                      _infoBox("Plan", user.product.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
