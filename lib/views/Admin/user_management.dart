import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/user_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/user_model.dart';
import 'package:deebee_user/views/Admin/user_form.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  //refresh halaman setelah create/edit/delete
  late Future<List<UserModel>> usersFuture;
  @override
  void initState() {
    super.initState();
    usersFuture = UserRepository().getAllUsers();
  }

  Future<void> refreshUsers() async {
    setState(() {
      usersFuture = UserRepository().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Center Judul Halaman
            const Center(
              child: Text(
                'Manajemen Pengguna',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            //Button Buat Pengguna Baru
            ButtonCreateAdmin(
              text: "Buat Pengguna Baru",
              onPressed: () async {
                final result = await context.push(
                  UserFormPage(title: "Buat Pengguna Baru", user: null),
                );

                //refresh halaman setelah dari UserFormPage
                if (result == true) {
                  refreshUsers();
                }
              },
            ),
            const SizedBox(height: 20),

            //List Pengguna (listview dibungkus FutureBuilder)
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                //panggil fungsi getAllUsers()
                future: usersFuture,
                builder: (context, snapshot) {
                  // 1. Kondisi Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 2. Kondisi Gagal/Error
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Gagal memuat data pengguna"),
                    );
                  }
                  // 3. Kondisi Data Kosong
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada data pengguna"));
                  }
                  // Data berhasil didapatkan
                  final List<UserModel> users = snapshot.data!;

                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: users.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      //var assign kolom
                      final currentUser = users[index];

                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          //Avatar
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryHoney.withValues(
                              alpha: 0.2,
                            ),
                            backgroundImage: AssetImage(
                              "assets/images/avatars/user-avatars-${currentUser.avatarIndex}.jpg",
                            ),
                          ),
                          //nama user
                          title: Text(
                            currentUser.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          //role
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              currentUser.role,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final result = await context.push(
                              UserFormPage(
                                title: "Edit Pengguna",
                                user: currentUser,
                              ),
                            );
                            //refresh halaman setelah dari UserFormPage
                            if (result == true) {
                              refreshUsers();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
