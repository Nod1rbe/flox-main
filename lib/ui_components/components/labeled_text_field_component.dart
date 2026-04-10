import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flutter/material.dart';

class LabeledTextFieldComponent extends StatelessWidget {
  final String title;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextStyle titleTextStyle;
  final EdgeInsets margin;
  final TextEditingController? controller;

  const LabeledTextFieldComponent({
    super.key,
    required this.title,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.controller,
    this.titleTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: titleTextStyle),
          const SizedBox(height: 2),
          TextFieldAtom(
            controller: controller,
            hintText: hintText,
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
