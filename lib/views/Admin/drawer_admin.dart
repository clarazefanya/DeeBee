import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final menus = [
      "Home Admin",
      "Asset Scene",
      "Manajemen Pengguna",
      "DB Structure Viewer",
    ];

    return Drawer(
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              menus[index],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            selected: selectedIndex == index,
            selectedTileColor: AppColors.primaryHoney,
            onTap: () {
              onSelected(index);
              Navigator.pop(context); // tutup drawer
            },
          );
        },
      ),
    );
  }
}

// class DrawerAdmin extends StatefulWidget {
//   const DrawerAdmin({super.key});

//   @override
//   State<DrawerAdmin> createState() => _DrawerAdminState();
// }

// class _DrawerAdminState extends State<DrawerAdmin> {
//   //var drawer
//   int _selectedIndex = 0;

//   //menu drawer
//   final List<String> drawerMenus = [
//     "Home Admin",
//     "Gambar Aset Gameplay",
//     "Manajemen User",
//     "DB Structure Viewer",
//   ];

//   //halaman yg dibuka drawer
//   static const List<Widget> _drawerOptions = <Widget>[
//     Home(mode: HomeMode.admin),
//     Text("masterdata gambar"),
//     Text("manajemen user"),
//     Text("DB Struture Viewer pakai sqlite_viewer2"),
//   ];

//   //logic jika dipencet
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       Navigator.pop(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView.builder(
//           itemCount: drawerMenus.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(drawerMenus[index]),
//               selected: _selectedIndex == index,
//               selectedTileColor: AppColors.primaryHoney,
//               onTap: () => _onItemTapped(index),
//             );
//           },
//         ),
//       ),
//       body: Center(child: _drawerOptions.elementAt(_selectedIndex)),
//     );
//   }
// }
