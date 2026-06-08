import 'package:flutter/material.dart';

class AssetGameplay extends StatefulWidget {
  const AssetGameplay({super.key});

  @override
  State<AssetGameplay> createState() => _AssetGameplayState();
}

class _AssetGameplayState extends State<AssetGameplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DeebeeAppbar(
      //   leading: Builder(builder: (context) => IconDrawerAdmin()),
      // ),
      body: Center(child: Text("Gameplay Asset")),
    );
    // return AdminScaffold(
    //   selectedDrawerIndex: 1,
    //   body: Center(child: Text("Gameplay Asset")),
    // );
  }
}
