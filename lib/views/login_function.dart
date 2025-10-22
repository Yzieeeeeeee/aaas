import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/current_user.dart'; // your Welcome model

class FunctionPage extends StatefulWidget {
  final String accessToken; // <-- Pass this after login

  const FunctionPage({super.key, required this.accessToken});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  late Future<Welcome> _futureProfile;

  Future<Welcome> fetchSpotifyProfile() async {
    final url = Uri.parse("https://api.spotify.com/v1/me");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${widget.accessToken}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Welcome.fromJson(data);
    } else {
      throw Exception(
        "Failed to load profile (status: ${response.statusCode}) — ${response.body}",
      );
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
        title: const Text("Spotify Profile", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<Welcome>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "❌ Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No profile data found", style: TextStyle(color: Colors.white)),
            );
          }

          final user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user.images.isNotEmpty)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.images[0]['url']),
                  ),
                const SizedBox(height: 20),
                Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 20)),
                Text(user.email, style: const TextStyle(color: Colors.white70)),
                Text(user.country, style: const TextStyle(color: Colors.white54)),
                const SizedBox(height: 10),
                Text("Followers: ${user.followers.total}",
                    style: const TextStyle(color: Colors.greenAccent)),
              ],
            ),
          );
        },
      ),
    );
  }
}
