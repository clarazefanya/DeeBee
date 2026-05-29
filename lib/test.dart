import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _testState();
}

class _testState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              //test 2 button
              Expanded(
                child: ButtonComponent(text: "button 1", bgcolor: Colors.white),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ButtonComponent(
                  text: "button2",
                  bgcolor: AppColors.primaryHoney,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
