import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/cubit/button_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonConfigWidget extends StatelessWidget {
  const ButtonConfigWidget({super.key, required this.config, required this.isSelected});

  final ButtonConfig config;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonViewCubit, ButtonViewState>(
      listener: (context, state) {
        debugPrint('ButtonConfig widget updated: ${state.config.toString()}');
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
          Container(
            height: config.height,
            width: config.width,
            margin: config.padding,
            alignment: config.alignment,
            decoration: BoxDecoration(
              color: config.buttonColor,
              borderRadius: BorderRadius.circular(config.radius),
            ),
            child: Text(
              config.text,
              style: TextStyle(
                color: config.textColor,
                fontSize: config.textSize,
                fontWeight: config.textWeight,
              ).withGoogleFont(config.fontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
