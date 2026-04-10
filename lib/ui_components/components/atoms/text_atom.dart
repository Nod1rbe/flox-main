import 'package:flutter/material.dart';

class TextAtom extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fontFamily;
  final double? letterSpacing;
  final double? height;
  final EdgeInsets padding;

  const TextAtom({
    super.key,
    required this.text,
    this.fontSize = 12.0,
    this.color = Colors.white,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
    this.fontFamily,
    this.letterSpacing,
    this.height,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
          height: height,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
