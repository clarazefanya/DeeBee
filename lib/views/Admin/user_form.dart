import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {
  final String title; // "Buat Pengguna Baru" atau "Edit Pengguna"

  const UserFormPage({super.key, required this.title});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _userFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _selectedRole;
  final List<String> _listRole = ['user', 'admin'];

  List<String> avatars = [
    'assets/images/avatars/user-avatars-1.jpg',
    'assets/images/avatars/user-avatars-2.jpg',
    'assets/images/avatars/logodb2.jpg',
  ];
  int selectedAvatar = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          child: Form(
            key: _userFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row Panah Back dan Judul Dinamis
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Input Nama
                const Text(
                  "Nama",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFieldComponent(
                  hinttext: 'Siapa namamu?',
                  textFieldCont: nameController,
                  textFieldVal: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama wajib diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Email
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFieldComponent(
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
                const SizedBox(height: 16),

                // Input Password
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFieldComponent(
                  hinttext: 'Minimal 8 karakter',
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
                const SizedBox(height: 16),

                // Dropdown Role
                const Text(
                  "Role",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                DropdownFieldComponent(
                  value: _selectedRole,
                  hinttext: 'Pilih Role',
                  items: _listRole,
                  onChanged: (val) => setState(() => _selectedRole = val),
                  validator: (val) => val == null ? 'Wajib pilih role' : null,
                ),
                const SizedBox(height: 16),

                // Pilih Avatar
                const Text(
                  "Pilih Avatar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                const SizedBox(height: 20),

                // Row Action Buttons: Simpan & Hapus
                Column(
                  children: [
                    // Tombol Simpan
                    ButtonComponent(
                      text: "Simpan",
                      bgcolor: AppColors.primaryHoney,
                      onPressed: () {
                        if (_userFormKey.currentState!.validate()) {
                          // Logic insert/update database nanti di sini
                        }
                      },
                    ),

                    // Tombol Hapus (Hanya muncul saat mode Edit, create tidak)
                    if (widget.title == "Edit Pengguna") ...[
                      const SizedBox(height: 15),
                      ButtonComponent(
                        text: "Hapus Pengguna",
                        bgcolor: AppColors.redComponent,
                        onPressed: () {
                          // Logic hapus database nanti di sini
                        },
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
