import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/cupertino.dart';

class ButtonAtom extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;
  final IconData? iconData;
  final double borderRadius;
  final bool loading;
  final Color splashColor;
  final Color? highLightColor;
  final EdgeInsets padding;
  final double height;
  final double? width;
  final Color circularProgressColor;
  final Widget? child;
  final Color textColor;
  final TextStyle? textStyle;
  final Color disabledTextColor;
  final Color disabledColor;
  final Color color;
  final BoxBorder? border;
  final EdgeInsets margin;
  final Color hoverColor;

  const ButtonAtom({
    super.key,
    this.text = '',
    required this.onTap,
    this.iconData,
    this.isDisabled = false,
    this.borderRadius = 12,
    this.loading = false,
    this.splashColor = AppColors.defaultSplashColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.height = 46,
    this.width,
    this.circularProgressColor = AppColors.white,
    this.child,
    this.textColor = AppColors.defaultButtonTextColor,
    this.disabledTextColor = AppColors.disabledTextColor,
    this.textStyle,
    this.disabledColor = AppColors.disabledColor,
    this.color = AppColors.primary,
    this.border,
    this.margin = EdgeInsets.zero,
    this.highLightColor,
    this.hoverColor = AppColors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDisabled ? disabledColor : color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: TappableComponent(
          onTap: onTap,
          highlightColor: highLightColor,
          hoverColor: hoverColor,
          borderRadius: borderRadius,
          splashColor: splashColor,
          disabled: isDisabled,
          child: Container(
            height: height,
            width: width,
            padding: padding,
            alignment: Alignment.center,
            child: loading
                ? Center(child: CupertinoActivityIndicator(color: circularProgressColor))
                : child ??
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDisabled ? disabledTextColor : textColor,
                      ),
                      child: Text(
                        text,
                        style: textStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
