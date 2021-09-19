import 'package:flutter/material.dart';

class InputLogin extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool isPassword;
  const InputLogin(
      {Key? key,
      required this.hintText,
      this.icon = Icons.email_outlined,
      this.isPassword = false,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.only(top: 10),
        width: size.width - 40,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25)),
        child: TextField(
          obscureText: isPassword,
          onChanged: onChanged,
          decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.black,
              ),
              border: InputBorder.none,
              hintText: hintText),
        ));
  }
}
