import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldAtom extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final EdgeInsets contentPadding;
  final EdgeInsets outerPadding;
  final List<TextInputFormatter>? inputFormatters;
  final Color fillColor;
  final String hintText;
  final double? width;
  final double height;
  final double borderRadius;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final String? headerText;
  final String? initialValue;
  final TextStyle headerTextStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextAlign textAlign;

  const TextFieldAtom({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.outerPadding = EdgeInsets.zero,
    this.inputFormatters,
    this.width,
    this.fillColor = AppColors.fillColor,
    this.hintText = '',
    this.borderRadius = 12,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.headerText,
    this.height = 48,
    this.obscureText = false,
    this.suffixIcon,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.headerTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
    this.initialValue,
  });

  @override
  State<TextFieldAtom> createState() => _TextFieldAtomState();
}

class _TextFieldAtomState extends State<TextFieldAtom> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerText != null) ...[
            Text(widget.headerText!, style: widget.headerTextStyle),
            const SizedBox(height: 4),
          ],
          SizedBox(
            height: widget.maxLines == 1 ? widget.height : null,
            width: widget.width,
            child: TextFormField(
              focusNode: widget.focusNode,
              validator: widget.validator,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign,
              obscureText: _isObscure,
              obscuringCharacter: '•',
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              initialValue: widget.initialValue,
              style: const TextStyle(color: AppColors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: widget.obscureText ? _toggleObscure() : widget.suffixIcon,
                hintStyle: TextStyle(
                  color: AppColors.hintText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: widget.fillColor,
                contentPadding: widget.contentPadding,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: AppColors.errorBorderColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleObscure() {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 8, bottom: 8),
      child: TappableComponent(
        onTap: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
        borderRadius: 6,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: _isObscure
              ? Assets.icons.eyeSlash.svg(
                  colorFilter: ColorFilter.mode(
                  const Color(0xFFA0A0A0),
                  BlendMode.srcIn,
                ))
              : Assets.icons.eye.svg(
                  colorFilter: ColorFilter.mode(
                  const Color(0xFFA0A0A0),
                  BlendMode.srcIn,
                )),
        ),
      ),
    );
  }
}
