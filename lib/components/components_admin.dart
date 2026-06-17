import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

/// BUTTON ADMIN ///

// BUTTON CREATE ADMIN
class ButtonCreateAdmin extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonCreateAdmin({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryHoney),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_outlined),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// BUTTON ACTION ADMIN
class ButtonActionAdmin extends StatelessWidget {
  final String text;
  final Color bgColor;
  final VoidCallback onPressed;

  const ButtonActionAdmin({
    super.key,
    required this.text,
    required this.bgColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.all(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlack,
        ),
      ),
    );
  }
}

// ICON ACTION ADMIN
class ActionCircleAdmin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCircleAdmin({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

// ICON DRAWER ADMIN
class IconDrawerAdmin extends StatelessWidget {
  const IconDrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

// SCAFFOLD KHUSUS HALAMAN ADMIN (KECUALI HOME)
// class AdminScaffold extends StatelessWidget {
//   const AdminScaffold({
//     super.key,
//     required this.selectedDrawerIndex,
//     required this.body,
//   });

//   final int selectedDrawerIndex;
//   final Widget body;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: DrawerAdmin(
//         selectedIndex: selectedDrawerIndex,
//         onSelected: (index) {
//           // routing drawer
//         },
//       ),
//       appBar: DeebeeAppbar(
//         leading: Builder(builder: (context) => const IconDrawerAdmin()),
//       ),
//       body: body,
//     );
//   }
// }
