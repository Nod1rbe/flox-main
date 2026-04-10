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
    final bgColor = widget.isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.1);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: widget.onTap,
              child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.layoutBackground,
                  ),
                ),
              ),
            ),
          ),
          _isHovering
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close_rounded, size: 14, color: AppColors.white),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
