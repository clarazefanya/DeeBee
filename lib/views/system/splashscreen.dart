import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/auth/login.dart';
import 'package:deebee_user/views/navigation/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserRepositoryFirebase _userRepositoryFirebase =
      UserRepositoryFirebase();

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    // Ambil data user dari Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    if (currentUser == null) {
      // Jika user tdk ada di firebase Auth, ke hlmn login
      context.pushReplacement(Login());
      return;
    }

    // Ambil data user dari Firestore
    final pengguna = await _userRepositoryFirebase.getUserByUid(
      currentUser.uid,
    );

    if (pengguna == null) {
      // Jika user tdk ada di firebase, sign out dan ke hlmn login
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      context.pushReplacement(Login());
      return;
    }

    // Simpan lagi ke SharedPreferences (cache)
    await PreferenceHandler.setUserUid(currentUser.uid);
    await PreferenceHandler.setUserId(2);
    await PreferenceHandler.setRole(pengguna.role);
    await PreferenceHandler.setAvatarIndex(pengguna.avatarIndex);

    if (!mounted) return;
    context.pushReplacement(BottomNavBar());
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
