import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'spotify_profile_page.dart'; // Your profile page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Spotify credentials
  final String clientId = "1684c9e127f047ebbec2e56d268296cb";
  final String clientSecret = "de5651673dca44af8609e2652ac40d31";
  final String redirectUri = "musicplayer://callback"; // Must match Spotify Dashboard

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginWithSpotify() async {
    final authUrl =
        "https://accounts.spotify.com/authorize?response_type=code"
        "&client_id=$clientId"
        "&scope=user-read-email%20user-read-private"
        "&redirect_uri=$redirectUri";
    print(clientId);
    print(redirectUri);

    try {
      // Step 1: Open Spotify login page
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "musicplayer", // Must match redirectUri scheme
      );
print('hello');      // Step 2: Get authorization code from redirect
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception("Authorization code not found");

      // Step 3: Exchange code for access token
      final token = await _exchangeCodeForToken(code);

      // Step 4: Navigate to profile page with token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpotifyProfilePage(token: token),
        ),
      );
    } catch (e) {
      print("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Spotify login failed: $e")),
      );
    }
  }

  Future<String> _exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri,
        "client_id": clientId,
        "client_secret": clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["access_token"];
    } else {
      throw Exception("Failed to get access token: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.music_note, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Spotify Clone",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _loginWithSpotify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('LOG IN WITH SPOTIFY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
