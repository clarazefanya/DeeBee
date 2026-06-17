import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/auth/login.dart';
import 'package:deebee_user/views/navigation/bottom_navbar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isLogin = PreferenceHandler.isLogin;
    if (!mounted) return;

    if (isLogin) {
      context.pushReplacement(BottomNavBar()); //halaman home (bottom navbar)
    } else {
      context.pushReplacement(Login()); //halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logodb-transparan.png",
              height: 128,
              width: 128,
            ),
            Text(
              "DeeBee",
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),

            Text("Loading..."),
            SizedBox(height: 10),

            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
