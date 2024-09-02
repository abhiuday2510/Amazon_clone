import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String text;
  //always use this for accepting callback function like onpressed
  final VoidCallback onTap;

  final Color? backgroundColor;

  final Color? foregroundColor;

  const CustomButton({Key? key, required this.text, required this.onTap, this.backgroundColor, this.foregroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor
      ),
        child: Text(text),
    );
  }
}
