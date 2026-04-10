import 'dart:developer';

import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/cubit/multiple_choice_view_cubit.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultipleChoiceConfigWidget extends StatefulWidget {
  const MultipleChoiceConfigWidget({
    super.key,
    required this.config,
    required this.isSelected,
    this.onOptionSelected,
  });

  final MultipleChoiceConfig config;
  final bool isSelected;
  final Function(int, bool)? onOptionSelected;

  @override
  State<MultipleChoiceConfigWidget> createState() => _MultipleChoiceConfigWidgetState();
}

class _MultipleChoiceConfigWidgetState extends State<MultipleChoiceConfigWidget> {
  @override
  void initState() {
    log(widget.config.defaultStyle.backgroundColor.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MultipleChoiceViewCubit, MultipleChoiceViewState>(
      listener: (context, state) {
        debugPrint('MultipleChoiceConfig widget updated: ${state.toString()}');
        context.read<BuilderCubit>().updateSelectedConfig(state.config);
      },
      child: Stack(
        children: [
          if (widget.isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          Padding(
            padding: widget.config.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.config.optionValues.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelectedPreview = index == 0;
                final optionTextColor =
                    isSelectedPreview ? widget.config.selectedStyle.textColor : widget.config.defaultStyle.textColor;
                final optionFontSize =
                    isSelectedPreview ? widget.config.selectedStyle.fontSize : widget.config.defaultStyle.fontSize;
                final optionFontWeight =
                    isSelectedPreview ? widget.config.selectedStyle.fontWeight : widget.config.defaultStyle.fontWeight;
                final optionFontFamily =
                    isSelectedPreview ? widget.config.selectedStyle.fontFamily : widget.config.defaultStyle.fontFamily;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelectedPreview
                          ? widget.config.selectedStyle.backgroundColor
                          : widget.config.defaultStyle.backgroundColor,
                      borderRadius: BorderRadius.circular(widget.config.defaultStyle.cornerRadius),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: _getMainAxisAlignment(widget.config.defaultStyle.alignment),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.config.defaultStyle.showIcon)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              option.leadingIcon,
                              style: TextStyle(
                                fontSize: optionFontSize,
                                color: optionTextColor,
                                fontWeight: optionFontWeight,
                              ).withGoogleFont(optionFontFamily),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            option.text,
                            textAlign: widget.config.defaultStyle.alignment,
                            style: TextStyle(
                              color: optionTextColor,
                              fontSize: optionFontSize,
                              fontWeight: optionFontWeight,
                            ).withGoogleFont(optionFontFamily),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return MainAxisAlignment.start;
      case TextAlign.right:
      case TextAlign.end:
        return MainAxisAlignment.end;
      case TextAlign.center:
        return MainAxisAlignment.center;
      case TextAlign.justify:
        return MainAxisAlignment.spaceBetween;
    }
  }
}
