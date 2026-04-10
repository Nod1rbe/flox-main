import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/enums/ui_enums/main_navigation_enum.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';

class NavigationListItem extends StatefulWidget {
  final MainNavigationEnum navItem;
  final bool isActive;
  final VoidCallback onTap;
  const NavigationListItem({
    super.key,
    required this.navItem,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<NavigationListItem> createState() => _NavigationListItemState();
}

class _NavigationListItemState extends State<NavigationListItem> {
  final Duration _animationDuration = const Duration(milliseconds: 200);
  final Curve _animationCurve = Curves.easeInOut;
  final double itemWidth = 218;
  @override
  Widget build(BuildContext context) {
    final Color contentColor = widget.isActive ? AppColors.white : AppColors.subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TappableComponent(
        onTap: widget.onTap,
        borderRadius: 8,
        splashColor: AppColors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: _animationDuration,
                curve: _animationCurve,
                left: widget.isActive ? 0 : -itemWidth,
                right: widget.isActive ? 0 : itemWidth,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  opacity: widget.isActive ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: widget.navItem.icon.svg(
                        colorFilter: ColorFilter.mode(
                          contentColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: _animationDuration,
                        curve: _animationCurve,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                          color: contentColor,
                        ),
                        child: Text(
                          widget.navItem.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
