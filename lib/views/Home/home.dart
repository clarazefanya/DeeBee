import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/models/home_mode_model.dart';
import 'package:deebee_user/views/Admin/asset_scene.dart';
import 'package:deebee_user/views/Admin/drawer_admin.dart';
import 'package:deebee_user/views/Admin/user_management.dart';
import 'package:deebee_user/views/Home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_viewer2/sqlite_viewer.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.mode});

  final HomeMode mode;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //drawer admin
  int _selectedAdminPage = 0;

  final List<Widget> adminPages = [
    const HomeContent(mode: HomeMode.admin),
    const AssetScene(),
    const UserManagement(),
    const DatabaseList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: widget.mode == HomeMode.admin
          ? DrawerAdmin(
              selectedIndex: _selectedAdminPage,
              onSelected: (index) {
                setState(() {
                  _selectedAdminPage = index;
                });
              },
            )
          : null,
      appBar: DeebeeAppbar(
        //jika mode admin, tampilkan icon drawer admin
        leading: widget.mode == HomeMode.admin
            ? Builder(builder: (context) => IconDrawerAdmin())
            : null,
      ),
      body:
          //jika mode admin, tampilkan halaman sesuai drawer admin. selain admin maka tampilkan home biasa
          widget.mode == HomeMode.admin
          ? adminPages[_selectedAdminPage]
          : const HomeContent(mode: HomeMode.user),
    );
  }
}
