import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/payment_config/cubit/payment_view_cubit.dart';
import 'package:flox/feature/builder/configs/payment_config/payment_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentConfigWidget extends StatelessWidget {
  const PaymentConfigWidget({super.key, required this.config, required this.isSelected});

  final PaymentConfig config;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentViewCubit, PaymentViewState>(
      listener: (context, state) {
        debugPrint('PaymentConfig widget updated: ${state.config.toString()}');
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Material(
                        color: config.textFieldConfig.backgroundColor,
                        borderRadius: BorderRadius.circular(config.textFieldConfig.cornerRadius),
                        child: IgnorePointer(
                          child: TextFormField(
                            initialValue: '4242 4242 4242 4242',
                            readOnly: true,
                            textAlign: _mapAlignmentToTextAlign(config.textFieldConfig.alignment),
                            style: TextStyle(
                              color: config.textFieldConfig.textColor,
                              fontSize: config.textFieldConfig.fontSize,
                              fontWeight: config.textFieldConfig.fontWeight,
                            ).withGoogleFont(config.textFieldConfig.fontFamily),
                            decoration: InputDecoration(
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color: config.textFieldConfig.backgroundColor,
                        borderRadius: BorderRadius.circular(config.textFieldConfig.cornerRadius),
                        child: IgnorePointer(
                          child: TextFormField(
                            initialValue: '12/26',
                            readOnly: true,
                            textAlign: _mapAlignmentToTextAlign(config.textFieldConfig.alignment),
                            style: TextStyle(
                              color: config.textFieldConfig.textColor,
                              fontSize: config.textFieldConfig.fontSize,
                              fontWeight: config.textFieldConfig.fontWeight,
                            ).withGoogleFont(config.textFieldConfig.fontFamily),
                            decoration: InputDecoration(
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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: config.buttonConfig.height,
                    width: config.buttonConfig.width,
                    alignment: config.buttonConfig.alignment,
                    decoration: BoxDecoration(
                      color: config.buttonConfig.buttonColor,
                      borderRadius: BorderRadius.circular(config.buttonConfig.radius),
                    ),
                    child: Text(
                      config.buttonConfig.text,
                      style: TextStyle(
                        color: config.buttonConfig.textColor,
                        fontSize: config.buttonConfig.textSize,
                        fontWeight: config.buttonConfig.textWeight,
                      ).withGoogleFont(config.buttonConfig.fontFamily),
                    ),
                  ),
                ),
              ],
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
