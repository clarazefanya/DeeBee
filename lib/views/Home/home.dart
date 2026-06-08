import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/models/home_mode.dart';
import 'package:deebee_user/views/Admin/asset_gameplay.dart';
import 'package:deebee_user/views/Admin/drawer_admin.dart';
import 'package:deebee_user/views/Admin/user_management.dart';
import 'package:deebee_user/views/Home/home_content.dart';
import 'package:flutter/material.dart';

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
    const AssetGameplay(),
    const UserManagement(),
    Text("DB Structure Viewer pakai sqlite_viewer2"),
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

Widget banner({required Color color, required String text}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),

    alignment: Alignment.center,

    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
