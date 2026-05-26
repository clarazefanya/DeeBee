import 'package:deebee_user/constants/colors.dart';
import 'package:flutter/material.dart';

// TEXTFORMFIELD LOGIN REGISTER
class TextFieldComponent extends StatefulWidget {
  final IconData icon;
  final String hinttext;
  final bool isPassword; //untuk password

  const TextFieldComponent({
    super.key,
    required this.icon,
    required this.hinttext,
    this.isPassword = false, //optional hanya utk password
  });

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  //obsecure text utk password
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? obsecure : false,

      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        prefixIconColor: AppColors.primaryBrown,

        hintText: widget.hinttext,
        hintStyle: TextStyle(color: const Color(0xFF626566), fontSize: 14),

        //icon hide/show utk password. Jika isPassword true, return icon
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obsecure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primaryBrown,
                ),
                onPressed: () {
                  setState(() {
                    obsecure = !obsecure;
                  });
                },
              )
            : null,

        // tinggi textfield (padding hintext)
        // contentPadding: EdgeInsets.symmetric(vertical: 17),

        // warna background textfield
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

// BUTTON
class ButtonComponent extends StatefulWidget {
  final String text;
  final Color bgcolor;
  // final VoidCallback onPressed;

  const ButtonComponent({
    super.key,
    required this.text,
    required this.bgcolor,
    // required this.onPressed,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
