import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/views/home.dart';
import 'package:deebee_user/views/profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  String role = "user"; //var role

  List<Widget> get _listHalaman => [
    const Home(),
    if (role == 'admin') const Text('Halaman Admin Coming Soon'),
    const Text('Halaman LeaderBoard Coming Soon'),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Fungsi helper item navbar
  BottomNavigationBarItem _buildNavItem(IconData selectedIcon, String label) {
    return BottomNavigationBarItem(
      // Icon saat tidak dipilih
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(selectedIcon, color: AppColors.primaryHoney),
      ),
      // Icon dengan background lingkaran saat dipilih
      activeIcon: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.primaryHoney,
          shape: BoxShape.circle,
        ),
        child: Icon(selectedIcon, color: Colors.white),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _listHalaman.elementAt(_selectedIndex)),
      //container utk border dan border radius
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          // color: AppColors.background,
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          border: Border(
            top: BorderSide(color: AppColors.primaryHoney, width: 1.5),
          ),
        ),
        //gunakan ClipRRect agar isi Navbar tidak menabrak batas lengkungan
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              _buildNavItem(Icons.home, 'Home'),
              if (role == 'admin') _buildNavItem(Icons.assignment_ind, 'Admin'),
              _buildNavItem(Icons.leaderboard, 'Leaderboard'),
              _buildNavItem(Icons.person, 'Profil'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,

            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryHoney,
            unselectedItemColor: AppColors.primaryBlack,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
