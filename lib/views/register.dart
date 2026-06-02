import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //dummy data, nanti gambarnya diganti
  List<String> avatars = [
    'assets/images/User Avatar.png',
    'assets/images/User Avatar.png',
    'assets/images/User Avatar.png',
  ];
  int? selectedAvatar;

  //validator form
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
          child: Column(
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
              SizedBox(height: 16),

              //selamat datang
              Text(
                "Selamat Datang di DeeBee!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 8),

              //subtext daftar sebagai pegawai baru
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "Daftar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.borderBrown,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          " sebagai pegawai baru dan mulai petualangan SQL-mu.",
                      style: TextStyle(
                        color: AppColors.borderBrown,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              //input form register
              Form(
                key: _registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //nama
                    Text("Nama", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFieldComponent(
                      icon: Icons.person_outline,
                      hinttext: 'Siapa namamu?',
                      textFieldCont: nameController,
                      //textfieldval
                    ),
                    SizedBox(height: 16),

                    //email
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.email_outlined,
                      hinttext: 'example@email.com',
                      textFieldCont: emailController,
                      //textfieldval
                    ),
                    SizedBox(height: 16),

                    //password
                    Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.lock_outline,
                      hinttext: 'Minimal 8 karakter',
                      isPassword: true,
                      textFieldCont: passwordController,
                      //textfieldval
                    ),
                    SizedBox(height: 16),

                    //konfirmasi password
                    Text(
                      "Konfirmasi Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFieldComponent(
                      icon: Icons.verified_user_outlined,
                      hinttext: 'Ulangi password',
                      isPassword: true,
                      textFieldCont: confirmpasswordController,
                      //textfieldval
                    ),
                    SizedBox(height: 16),

                    //pilih avatar
                    Text(
                      "Pilih Avatar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: avatars.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 90,
                      ),

                      itemBuilder: (context, index) {
                        bool selected = selectedAvatar == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAvatar = index;
                            });
                          },

                          child: Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? AppColors.primaryHoney
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(avatars[index]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    //button daftar
                    ButtonComponent(
                      text: "Daftar",
                      bgcolor: AppColors.primaryHoney,
                      onPressed: () {},
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              //sudah punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.borderBrown,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(Login());
                    },
                    child: Text(
                      "Masuk",
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
}
