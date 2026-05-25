import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

//textformfield login register
class TextFieldComponent extends StatelessWidget {
  final IconData icon;
  final String hinttext;

  const TextFieldComponent({
    super.key,
    required this.icon,
    required this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconColor: AppColors.primaryBrown,

        hintText: hinttext,
        hintStyle: TextStyle(color: const Color(0xFF626566), fontSize: 14),

        filled: true,
        fillColor: Color(0xFFFFFFFF),

        // border normal
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBrown, width: 1),
        ),

        // border saat belum fokus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBrown, width: 1),
        ),

        // border saat diklik/focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBrown, width: 2),
        ),

        // border saat input salah
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

//yellow button full
class ButtonFullComponent extends StatelessWidget {
  final String text;
  // final VoidCallback onPressed;

  const ButtonFullComponent({
    super.key,
    required this.text,
    // required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryHoney,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
