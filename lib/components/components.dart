import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/user_repository.dart';
import 'package:flutter/material.dart';

// TEXTFORMFIELD LOGIN REGISTER
class TextFieldComponent extends StatefulWidget {
  final IconData? icon;
  final String? hinttext;
  final int? lines;
  final bool isPassword; //untuk password
  final String? Function(String?)? textFieldVal;
  final TextEditingController textFieldCont;

  const TextFieldComponent({
    super.key,
    this.icon,
    this.hinttext,
    this.lines = 1,
    this.isPassword = false, //optional hanya utk password
    this.textFieldVal,
    required this.textFieldCont,
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
      controller: widget.textFieldCont,
      validator: widget.textFieldVal,
      maxLines: widget.isPassword ? 1 : widget.lines,

      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        prefixIconColor: AppColors.borderBrown,

        hintText: widget.hinttext,
        hintStyle: TextStyle(
          color: const Color(0xFF626566),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        //icon hide/show utk password. Jika isPassword true, return icon
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obsecure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.borderBrown,
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
          borderSide: BorderSide(color: AppColors.borderBrown, width: 1),
        ),

        // border saat belum fokus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBrown, width: 1),
        ),

        // border saat diklik/focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderBrown, width: 2),
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

// DROPDOWN CREATE SCENE
class DropdownFieldComponent extends StatelessWidget {
  final String? value;
  final String hinttext;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const DropdownFieldComponent({
    super.key,
    required this.value,
    required this.hinttext,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      hint: Text(
        hinttext,
        style: const TextStyle(color: Color(0xFF626566), fontSize: 14),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderBrown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

// BUTTON
class ButtonComponent extends StatefulWidget {
  final String text;
  final Color bgcolor;
  final VoidCallback? onPressed;

  const ButtonComponent({
    super.key,
    required this.text,
    required this.bgcolor,
    required this.onPressed,
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
        onPressed: widget.onPressed,
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

// APPBAR
class DeebeeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DeebeeAppbar({super.key, this.leading});

  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    //Ambil avatar index dari SharedPreferences
    final int currentAvatarIndex = PreferenceHandler.avatarIndex;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      leading: leading,
      title: Row(
        children: [
          Image.asset(
            "assets/images/logodb-transparan.png",
            width: 32,
            height: 32,
          ),
          SizedBox(width: 8),
          Text(
            "DeeBee",
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryCream,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.borderLightBrown),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //bungkus XP dengan FutureBuilder agar datanya real-time dari DB
              FutureBuilder<int>(
                future: UserRepository().getUserXp(),
                builder: (context, snapshot) {
                  //jika sukses tampilkan data, jika masih loading tampilkan tanda "-"
                  String xpText = snapshot.hasData
                      ? "${snapshot.data} XP"
                      : "- XP";
                  return Text(
                    xpText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(
                  "assets/images/avatars/user-avatars-$currentAvatarIndex.jpg",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ICON APPBAR GAMEPLAY
class IconAppbarGameplay extends StatelessWidget {
  const IconAppbarGameplay({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        // buka popup gameplay
      },
    );
  }
}

// POP UP GAMEPLAY

// COMPONENT LAIN LAGI
