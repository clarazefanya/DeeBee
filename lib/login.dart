import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                    color: AppColors.primaryBrown,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " dan lanjutkan progres belajarmu.",
                      style: TextStyle(
                        color: AppColors.primaryBrown,
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
                    ),
                    SizedBox(height: 16),

                    //button masuk
                    ButtonFullComponent(text: "Masuk"),
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
                      color: AppColors.primaryBrown,
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

  // ElevatedButton ButtonFullComponent() {
  //   return ElevatedButton(
  //                 onPressed: () {
  //                   setState(() {});
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.primaryHoney,
  //                   minimumSize: Size(double.infinity, 56),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(9999),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   "Masuk",
  //                   style: TextStyle(
  //                     color: AppColors.primaryBlack,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               );
  // }

  // TextFormField textFieldComponent(IconData icon, String hintext) {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(icon),
  //       prefixIconColor: AppColors.primaryBrown,

  //       hintText: hintext,
  //       hintStyle: TextStyle(color: const Color(0xFF626566), fontSize: 14),

  //       filled: true,
  //       fillColor: Color(0xFFFFFFFF),

  //       // border normal
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: AppColors.primaryBrown, width: 1),
  //       ),

  //       // border saat belum fokus
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: AppColors.primaryBrown, width: 1),
  //       ),

  //       // border saat diklik/focus
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: AppColors.primaryBrown, width: 2),
  //       ),

  //       // border saat input salah
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: Colors.red, width: 2),
  //       ),
  //     ),
  //   );
  // }
}
