import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {
  final String title; // "Buat Pengguna Baru" atau "Edit Pengguna"
  final UserModel? user; // null jika Create, terisi jika Edit

  const UserFormPage({super.key, required this.title, this.user});

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
    'assets/images/avatars/user-avatars-0.jpg',
    'assets/images/avatars/user-avatars-1.jpg',
    'assets/images/avatars/user-avatars-2.jpg',
  ];
  int selectedAvatar = 0;

  int _statusAktif = 1; //radio button status

  // Jika widget.user ada isinya (Mode Edit), isi semua field secara otomatis
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      nameController.text = widget.user!.name;
      emailController.text = widget.user!.email;
      passwordController.text = widget.user!.password;
      _selectedRole = widget.user!.role.toLowerCase();
      selectedAvatar = widget.user!.avatarIndex;
      _statusAktif = widget.user!.isActive ? 1 : 0;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //Ambil userId dari SharedPreferences (tdk bisa hapus diri sendiri)
  final int? currentUserId = PreferenceHandler.userId;

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

                // Radio button status
                const Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RadioGroup<int>(
                  groupValue: _statusAktif,
                  onChanged: (value) {
                    setState(() {
                      _statusAktif = value!;
                    });
                  },
                  child: Row(
                    children: [
                      Radio<int>(value: 1),
                      const Text("Aktif"),

                      const SizedBox(width: 16),

                      Radio<int>(value: 0),
                      const Text("Nonaktif"),
                    ],
                  ),
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
                      onPressed: save,
                    ),

                    // Tombol Hapus (Hanya muncul saat mode Edit, create tidak)
                    if (widget.title == "Edit Pengguna") ...[
                      const SizedBox(height: 15),
                      ButtonComponent(
                        text: "Hapus Pengguna",
                        bgcolor: AppColors.redComponent,
                        onPressed: () {
                          if (currentUserId == widget.user!.id) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tidak dapat menghapus diri sendiri',
                                ),
                              ),
                            );
                            return;
                          } else {
                            confirmDelete;
                          }
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

  //function tombol simpan
  void save() async {
    if (_userFormKey.currentState!.validate()) {
      // BIKIN MODEL BARU DARI INPUTAN
      final formUser = UserModel(
        id: widget.user?.id, // ID null jika create, ada isi jika edit
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        avatarIndex: selectedAvatar,
        role: _selectedRole!,
        isActive: _statusAktif == 1, // Konversi int ke boolean
        // Jika mode Edit, pertahankan data lama. Jika Create, set nilai awal.
        createdAt:
            widget.user?.createdAt ??
            DateTime.now().toLocal().toIso8601String(),
        lastLevelId: widget.user?.lastLevelId,
        xp: widget.user?.xp ?? 0,
      );

      bool isSuccess = false;
      if (widget.user == null) {
        // MODE CREATE: Panggil fungsi register
        isSuccess = await UserRepository().registerUser(formUser);
      } else {
        // MODE EDIT: Panggil fungsi update
        int rowsAffected = await UserRepository().updateUser(formUser);
        isSuccess = rowsAffected > 0;
      }

      if (!context.mounted) return;
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan!")),
        );
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email sudah dipakai atau Gagal menyimpan data"),
          ),
        );
      }
    }
  }

  //function tombol hapus pengguna
  void confirmDelete() {
    //tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Yakin ingin menghapus pengguna ini?"),
          actions: [
            // Tombol Batal
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Tutup dialog saja
              },
              child: const Text("Batal"),
            ),
            // Tombol Ya
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Tutup dialog dulu

                // Jalankan fungsi delete
                await UserRepository().deleteUser(widget.user!.id!);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pengguna berhasil dihapus")),
                );

                context.pop(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Ya, Hapus"),
            ),
          ],
        );
      },
    );
  }
}
