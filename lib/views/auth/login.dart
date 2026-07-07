import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/services/auth_service.dart';
import 'package:deebee_user/utils/firebase_error_helper.dart';
import 'package:deebee_user/views/auth/register.dart';
import 'package:deebee_user/views/navigation/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //validator form
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //panggil AuthService & UserRepositoryFirebase
  final AuthService _authService = AuthService();
  final UserRepositoryFirebase _userRepositoryFirebase =
      UserRepositoryFirebase();
  bool isLoading = false; //loading button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 118),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Image.asset(
                "assets/images/logodb-transparan.png",
                height: 128,
                width: 128,
              ),
              //nama app
              Text(
                "DeeBee",
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 24),

              //selamat datang
              Text(
                "Selamat Datang di DeeBee!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              //subtext masuk dan lanjutkan
              Text.rich(
                TextSpan(
                  text: "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.borderBrown,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " dan lanjutkan progres belajarmu.",
                      style: TextStyle(
                        color: AppColors.borderBrown,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              //input form login
              Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //email
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.email_outlined,
                      hinttext: 'example@email.com',
                      textFieldCont: emailController,
                      textFieldVal: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email wajib diisi";
                        } else if (!value.contains('@')) {
                          return "Email harus mengandung '@'";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    //password
                    Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.lock_outline,
                      hinttext: 'Password',
                      isPassword: true,
                      textFieldCont: passwordController,
                      textFieldVal: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password wajib diisi";
                        } else if (value.length < 8) {
                          return "Password terlalu singkat";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    //button masuk
                    ButtonComponent(
                      text: "Masuk",
                      bgcolor: AppColors.primaryHoney,
                      isLoading: isLoading,
                      onPressed: login,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              //belum punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.borderBrown,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(Register());
                    },
                    child: Text(
                      "Daftar disini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7C5800),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function button login
  void login() async {
    //Jalankan validator Form
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    // Button menampilkan loading
    setState(() {
      isLoading = true;
    });

    try {
      // Login ke Firebase Auth
      final credential = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Ambil UID
      final uid = credential.user!.uid;

      // Get user by id dari firestore
      final pengguna = await _userRepositoryFirebase.getUserByUid(uid);

      if (!mounted) return;

      // Kalau data user tidak ditemukan di Firestore
      if (pengguna == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data pengguna tidak ditemukan")),
        );
        return;
      }

      // Cek apakah user dibanned
      if (!pengguna.isActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Akun Anda telah dinonaktifkan."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // LOGIN BERHASIL & USER AKTIF
      //simpan data ke preferences
      await PreferenceHandler.setLogin(true);
      await PreferenceHandler.setUserId(2);
      await PreferenceHandler.setUserUid(uid);
      await PreferenceHandler.setRole(pengguna.role);
      await PreferenceHandler.setAvatarIndex(pengguna.avatarIndex);

      if (!mounted) return;
      context.pushReplacement(BottomNavBar());
    } on FirebaseAuthException catch (e) {
      // LOGIN GAGAL (error dari Firebase Auth)
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(firebaseAuthErrorMessage(e))));
    } catch (e) {
      // LOGIN GAGAL (untuk error lain)
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
