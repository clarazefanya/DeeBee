import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/user_model.dart';
import 'package:deebee_user/views/Profile/about_us.dart';
import 'package:deebee_user/views/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //Ambil userId dari SharedPreferences
    final int? currentUserId = PreferenceHandler.userId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),

      //listview dibungkus FutureBuilder
      body: FutureBuilder<UserModel?>(
        // Panggil fungsi getUserById
        future: currentUserId != null
            ? UserRepository().getUserById(currentUserId)
            : Future.value(null),
        builder: (context, snapshot) {
          //Kondisi Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //Kondisi Gagal/Data Kosong
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data profil"));
          }
          // Data user berhasil didapatkan
          final user = snapshot.data!;

          return ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                // alignment: Alignment.center,
                children: [
                  //background kotak kuning
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryHoney.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),

                  //komponen profile
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                    child: Column(
                      children: [
                        //nametag outer
                        Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          color: AppColors.primaryHoney,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          //card
                          child: Padding(
                            // padding: const EdgeInsets.symmetric(
                            //   vertical: 25,
                            //   horizontal: 8,
                            // ),
                            padding: const EdgeInsets.only(
                              top: 40,
                              bottom: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 25,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  //row logo dan tulisan deebee
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/logodb-transparan.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "DeeBee",
                                        style: TextStyle(
                                          fontFamily: 'Fredoka',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 28,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),

                                  //avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryHoney,
                                        width: 3,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        "assets/images/avatars/user-avatars-${user.avatarIndex}.jpg",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),

                                  //nama user
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  //role (jika admin tulis "Admin", selain itu "Karyawan")
                                  Text(
                                    user.role.toLowerCase() == 'admin'
                                        ? "Admin"
                                        : "Karyawan",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 32),

                                  //row email
                                  Row(
                                    children: [
                                      Icon(Icons.email_outlined),
                                      SizedBox(width: 8),
                                      Text(
                                        "Email",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(user.email),
                                    ],
                                  ),
                                  SizedBox(height: 12),

                                  //row bergabung
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined),
                                      SizedBox(width: 8),
                                      Text(
                                        "Bergabung",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        DateFormat(
                                          'dd MMMM yyyy',
                                          'id_ID',
                                        ).format(
                                          DateTime.parse(user.createdAt),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40),

                                  //capsule XP
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryHoney,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      "${user.xp} XP",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        //3 kotak statistik
                        // IntrinsicHeight(
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       //progress
                        //       Expanded(
                        //         flex: 1,
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 26,
                        //           ),
                        //           // padding: EdgeInsets.all(26),
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.circular(12),
                        //             border: Border.all(
                        //               color: AppColors.borderCream,
                        //             ),
                        //           ),
                        //           child: Column(
                        //             children: [
                        //               Container(
                        //                 padding: EdgeInsets.all(10),
                        //                 decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: AppColors.primaryHoney
                        //                       .withValues(alpha: 0.20),
                        //                 ),
                        //                 child: Icon(
                        //                   Icons.trending_up,
                        //                   color: const Color(0xFF7C5800),
                        //                 ),
                        //               ),
                        //               Spacer(),
                        //               SizedBox(height: 8),
                        //               Text(
                        //                 "Progres",
                        //                 style: TextStyle(fontSize: 13),
                        //               ),
                        //               Spacer(),
                        //               SizedBox(height: 8),
                        //               Text(
                        //                 "32%",
                        //                 style: TextStyle(
                        //                   fontSize: 20,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(width: 12),

                        //       //level selesai
                        //       Expanded(
                        //         flex: 1,
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 26,
                        //           ),
                        //           // padding: EdgeInsets.all(26),
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.circular(12),
                        //             border: Border.all(
                        //               color: AppColors.borderCream,
                        //             ),
                        //           ),
                        //           child: Column(
                        //             children: [
                        //               Container(
                        //                 padding: EdgeInsets.all(10),
                        //                 decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: AppColors.greenComponent
                        //                       .withValues(alpha: 0.20),
                        //                 ),
                        //                 child: Icon(
                        //                   Icons.check_circle,
                        //                   color: AppColors.greenComponent,
                        //                 ),
                        //               ),
                        //               Spacer(),
                        //               SizedBox(height: 8),
                        //               Text(
                        //                 "Level Selesai",
                        //                 style: TextStyle(fontSize: 13),
                        //                 textAlign: TextAlign.center,
                        //               ),
                        //               Spacer(),
                        //               SizedBox(height: 8),
                        //               Text(
                        //                 "42",
                        //                 style: TextStyle(
                        //                   fontSize: 20,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(width: 12),

                        //       // UNUSED //
                        //       //chapter
                        //       // Expanded(
                        //       //   flex: 1,
                        //       //   child: Container(
                        //       //     padding: EdgeInsets.symmetric(
                        //       //       horizontal: 16,
                        //       //       vertical: 26,
                        //       //     ),
                        //       //     // padding: EdgeInsets.all(26),
                        //       //     decoration: BoxDecoration(
                        //       //       color: Colors.white,
                        //       //       borderRadius: BorderRadius.circular(12),
                        //       //       border: Border.all(
                        //       //         color: AppColors.borderCream,
                        //       //       ),
                        //       //     ),
                        //       //     child: Column(
                        //       //       children: [
                        //       //         Container(
                        //       //           padding: EdgeInsets.all(10),
                        //       //           decoration: BoxDecoration(
                        //       //             shape: BoxShape.circle,
                        //       //             color: AppColors.blueComponent.withValues(
                        //       //               alpha: 0.20,
                        //       //             ),
                        //       //           ),
                        //       //           child: Icon(
                        //       //             Icons.menu_book_outlined,
                        //       //             color: Color(0xFF00687B),
                        //       //           ),
                        //       //         ),
                        //       //         Spacer(),
                        //       //         SizedBox(height: 8),
                        //       //         Text(
                        //       //           "Chapter",
                        //       //           style: TextStyle(fontSize: 13),
                        //       //         ),
                        //       //         Spacer(),
                        //       //         SizedBox(height: 8),
                        //       //         Text(
                        //       //           "4",
                        //       //           style: TextStyle(
                        //       //             fontSize: 20,
                        //       //             fontWeight: FontWeight.bold,
                        //       //           ),
                        //       //         ),
                        //       //       ],
                        //       //     ),
                        //       //   ),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 24),

                        //settings, feedback, about us
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderCream),
                          ),
                          // ClipRRect memastikan efek sentuhan (ripple) tidak keluar dari sudut lengkung
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //settings/pengaturan
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primaryHoney,
                                    radius: 16,
                                    child: Icon(
                                      Icons.settings_outlined,
                                      color: AppColors.primaryBlack,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text(
                                    'Pengaturan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    // color: Colors.grey,
                                  ),
                                  onTap: () {
                                    // Aksi saat ditekan
                                  },
                                ),

                                //garis pemisah
                                const Divider(
                                  height: 1,
                                  color: AppColors.borderCream,
                                ),

                                //feedback & bug report
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primaryHoney,
                                    radius: 16,
                                    child: Icon(
                                      Icons.bug_report_outlined,
                                      color: AppColors.primaryBlack,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text(
                                    'Feedback & Bug Report',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                      'https://docs.google.com/forms/d/e/1FAIpQLSd7dQMkufeVxIkxeFmj_bK6Pz7wGx2lKJ-yDIztApQfYPXqeg/viewform?usp=sharing&ouid=101347985935852050031',
                                    );

                                    if (!await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                ),

                                //garis pemisah
                                const Divider(
                                  height: 1,
                                  color: AppColors.borderCream,
                                ),

                                //tentang DeeBee (about us)
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primaryHoney,
                                    radius: 16,
                                    child: Icon(
                                      Icons.info_outline,
                                      color: AppColors.primaryBlack,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text(
                                    'Tentang DeeBee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    context.push(AboutUs());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        //manajemen data
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderCream),
                          ),
                          // ClipRRect
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //judul manajemen data
                                ListTile(
                                  title: const Text(
                                    'MANAJEMEN DATA',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                //garis pemisah
                                const Divider(
                                  height: 1,
                                  color: AppColors.borderCream,
                                ),

                                //reset progres
                                ListTile(
                                  leading: Icon(
                                    Icons.restart_alt,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  title: const Text(
                                    'Reset Progres',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {},
                                ),

                                //garis pemisah
                                const Divider(
                                  height: 1,
                                  color: AppColors.borderCream,
                                ),

                                //hapus akun
                                ListTile(
                                  leading: Icon(
                                    Icons.delete_forever_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  title: const Text(
                                    'Hapus Akun',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    if (user.role == 'admin') {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Akun admin tidak dapat dihapus',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (currentUserId != null) {
                                      confirmDeleteAccount(currentUserId);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        //button logout/keluar
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            side: BorderSide(
                              color: AppColors.borderBrown,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: AppColors.borderBrown,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Keluar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.borderBrown,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            //logic logout
                            await PreferenceHandler.logOut();
                            if (!context.mounted) return;
                            context.pushAndRemoveAll(Login());
                            // snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Berhasil Logout")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  //stack gambar lanyard
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.asset("assets/images/lanyard.png"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  //function tombol hapus akun
  void confirmDeleteAccount(int userId) {
    //tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Yakin ingin menghapus akun secara permanen?"),
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
                await UserRepository().deleteUser(userId);
                await PreferenceHandler.logOut();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil menghapus akun")),
                );

                context.pushReplacement(Login());
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
