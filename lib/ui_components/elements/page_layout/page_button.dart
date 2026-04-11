import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PageButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PageButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;
    final bgColor = selected ? AppColors.primary.withValues(alpha: 0.32) : AppColors.cardColor.withValues(alpha: 0.55);
    final borderColor = selected ? AppColors.primary : AppColors.dividerColor.withValues(alpha: 0.9);
    final fgColor = AppColors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4, top: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: fgColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
          _isHovering
              ? Positioned(
                  top: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.softError,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close_rounded, size: 13, color: AppColors.white),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
