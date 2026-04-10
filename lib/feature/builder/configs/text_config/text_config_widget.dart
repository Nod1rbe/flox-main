import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/text_config/cubit/text_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextConfigWidget extends StatelessWidget {
  const TextConfigWidget({super.key, required this.config, required this.isSelected});

  final TextConfig config;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TextViewCubit, TextViewState>(
      listener: (BuildContext context, TextViewState state) {
        debugPrint('TextConfig widget updated: ${state.config.toString()}');
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
            child: Row(
              children: [
                if (config.leadingIcon.isNotEmpty) ...[
                  Text(config.leadingIcon,
                      style: TextStyle(
                        color: config.color,
                        fontSize: config.size,
                        fontWeight: config.weight,
                      ).withGoogleFont(config.fontFamily)),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    config.text,
                    style: TextStyle(
                      color: config.color,
                      fontSize: config.size,
                      fontWeight: config.weight,
                    ).withGoogleFont(config.fontFamily),
                    textAlign: config.alignment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
