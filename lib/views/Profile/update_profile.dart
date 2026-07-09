import 'package:deebee_user/components/components.dart'; // Sesuaikan import kamu
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/user_model_firebase.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _userFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  List<String> avatars = [
    'assets/images/avatars/user-avatars-0.jpg',
    'assets/images/avatars/user-avatars-1.jpg',
    'assets/images/avatars/user-avatars-2.jpg',
  ];
  int selectedAvatar = 0;

  final _userRepo = UserRepositoryFirebase();
  UserModelFirebase? currentUser;

  //load user
  Future<void> loadUser() async {
    final uid = PreferenceHandler.userUid;

    if (uid == null) return;

    final user = await _userRepo.getUserByUid(uid);

    if (user == null) return;

    currentUser = user;

    nameController.text = user.name;
    selectedAvatar = user.avatarIndex;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void dispose() {
    nameController.dispose();
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
                        "Update Profile",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

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

                // Tombol Simpan
                ButtonComponent(
                  text: "Simpan",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///function tombol simpan
  Future<void> save() async {
    if (!_userFormKey.currentState!.validate()) return;
    final uid = PreferenceHandler.userUid;
    if (uid == null) return;

    await _userRepo.updateProfile(
      uid: uid,
      name: nameController.text.trim(),
      avatarIndex: selectedAvatar,
    );

    if (!mounted) return;
    await PreferenceHandler.setAvatarIndex(selectedAvatar);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diperbarui!")),
    );
    context.pop(true);
  }
}
