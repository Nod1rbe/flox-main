import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/text_field_config/cubit/text_field_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldConfigWidget extends StatelessWidget {
  const TextFieldConfigWidget({
    super.key,
    required this.config,
    required this.isSelected,
    this.initialText = "",
  });

  final TextFieldConfig config;
  final bool isSelected;
  final String initialText;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TextFieldViewCubit, TextFieldViewState>(
      listener: (context, state) {
        debugPrint('TextFieldConfig widget yangilandi: ${state.config.toString()}');
        context.read<BuilderCubit>().updateSelectedConfig(state.config);
      },
      child: Stack(
        children: [
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          Padding(
            padding: config.padding,
            child: Material(
              color: config.backgroundColor,
              borderRadius: BorderRadius.circular(config.cornerRadius),
              child: IgnorePointer(
                child: TextFormField(
                  initialValue: 'Sample text',
                  readOnly: true,
                  textAlign: _mapAlignmentToTextAlign(config.alignment),
                  style: TextStyle(
                    color: config.textColor,
                    fontSize: config.fontSize,
                    fontWeight: config.fontWeight,
                  ).withGoogleFont(config.fontFamily),
                  decoration: InputDecoration(
                    hintText: config.hintText,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextAlign _mapAlignmentToTextAlign(Alignment alignment) {
    if (alignment == Alignment.center) {
      return TextAlign.center;
    } else if (alignment == Alignment.centerRight) {
      return TextAlign.right;
    } else {
      return TextAlign.left;
    }
  }
}
