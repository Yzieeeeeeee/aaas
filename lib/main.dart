import 'package:flutter/material.dart';
import 'package:musicplayer/album_page.dart';
import 'package:musicplayer/spotify_profile_page.dart';

import 'login.dart';

void main(){runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,home:LoginPage());
  }
}
// SpotifyProfilePage(token: 'BQDX-4YgAZMd9WVgMWoTa5_5iBxpHU3rngWwtSKorJ1J0doive9IKVHaxRX5hjP59pRaiv9ZAUO3B_px2Mju_0JaWJucJWWkQRIvLSVIbD_nU-v76y-Qx_O84jXvMtHwPi5r8-XxJg0Dl2URou4of_z0M0R1u6GtGtJWPKQdlpuP2w10jN3TWxMBPHCStI37q4a5Eo-MnT4ZUcwTAXg4H9UxfGobNrUFLG7__LoFZ00wug')