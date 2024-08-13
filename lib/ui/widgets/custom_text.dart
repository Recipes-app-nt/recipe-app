import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  double? height;
  TextAlign? textAlign;
  CustomText({
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.textAlign,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
