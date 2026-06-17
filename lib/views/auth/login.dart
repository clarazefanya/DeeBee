import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/auth/register.dart';
import 'package:deebee_user/views/navigation/bottom_navbar.dart';
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

    //Panggil loginUser() di UserRepository, read
    final pengguna = await UserRepository().loginUser(
      emailController.text.trim(),
      passwordController.text,
    );

    //Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    //Cek hasil login
    if (pengguna != null) {
      //cek apakah user sedang di-banned
      if (!pengguna.isActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun Anda telah dinonaktifkan.'),
            backgroundColor: Colors.red,
          ),
        );
        return; //tidak bisa login
      }

      // LOGIN BERHASIL & USER AKTIF
      //simpan data ke preferences
      await PreferenceHandler.setLogin(true); //login true
      await PreferenceHandler.setUserId(pengguna.id!); //simpan ID
      await PreferenceHandler.setRole(pengguna.role); //simpan role
      await PreferenceHandler.setAvatarIndex(
        pengguna.avatarIndex,
      ); //simpan avatar

      if (!mounted) return;
      context.pushReplacement(BottomNavBar());
    } else {
      // LOGIN GAGAL (Email atau password salah)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah')),
      );
    }
  }
}
