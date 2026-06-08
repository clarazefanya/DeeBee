import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DeebeeAppbar(
      //   leading: Builder(builder: (context) => IconDrawerAdmin()),
      // ),
      body: Center(child: Text("user management")),
    );
    // return AdminScaffold(
    //   selectedDrawerIndex: 1,
    //   body: Center(child: Text("Gameplay Asset")),
    // );
  }
}
