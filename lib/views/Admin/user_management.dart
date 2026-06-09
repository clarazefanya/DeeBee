import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/views/Admin/user_form.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy dihardcode untuk disimulasikan ke ListView.separated
    final List<Map<String, String>> dummyUsers = [
      {'username': 'alex_admin', 'role': 'Admin'},
      {'username': 'budi_siswa', 'role': 'User'},
      {'username': 'siti_sql', 'role': 'User'},
      {'username': 'john_doe', 'role': 'User'},
      {'username': 'jane_doe', 'role': 'Admin'},
    ];

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
              onPressed: () {
                // Aksi tambah pengguna baru
                context.push(UserFormPage(title: "Buat Pengguna Baru"));
              },
            ),
            const SizedBox(height: 20),

            //List Pengguna
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: dummyUsers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
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
                      //Avatar bulat sempurna menggunakan CircleAvatar
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryHoney.withValues(
                          alpha: 0.2,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryHoney,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        dummyUsers[index]['username']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          dummyUsers[index]['role']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Aksi ketika user diklik (misal ke halaman edit/detail)
                        context.push(UserFormPage(title: "Edit Pengguna"));
                      },
                    ),
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
