import 'package:flox/core/constants/app_colors.dart'; // Make sure this import is correct
import 'package:flutter/material.dart';

class ShimmerElement extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  final Duration duration;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;

  final double width;
  final double height;
  final double radius;

  final EdgeInsets padding;
  final EdgeInsets margin;

  const ShimmerElement({
    super.key,
    required this.isLoading,
    this.duration = const Duration(milliseconds: 1000),
    this.baseColor = AppColors.layoutBackground,
    this.highlightColor = AppColors.defaultShimmerColor,
    this.direction = ShimmerDirection.ltr,
    this.width = 100,
    this.height = 40,
    this.radius = 12,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    required this.child,
  });

  @override
  State<ShimmerElement> createState() => _ShimmerElementState();
}

enum ShimmerDirection { ltr, rtl, ttb, btt }

class _ShimmerElementState extends State<ShimmerElement> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)..repeat(min: -0.5, max: 1.5, period: widget.duration);
  }

  @override
  void didUpdateWidget(ShimmerElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        _controller.repeat(min: -0.5, max: 1.5, period: widget.duration);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _getBegin(ShimmerDirection dir) {
    switch (dir) {
      case ShimmerDirection.ltr:
        return const Alignment(-1.0, -0.3);
      case ShimmerDirection.rtl:
        return const Alignment(1.0, -0.3);
      case ShimmerDirection.ttb:
        return const Alignment(-0.3, -1.0);
      case ShimmerDirection.btt:
        return const Alignment(-0.3, 1.0);
    }
  }

  Alignment _getEnd(ShimmerDirection dir) {
    switch (dir) {
      case ShimmerDirection.ltr:
        return const Alignment(1.0, 0.3);
      case ShimmerDirection.rtl:
        return const Alignment(-1.0, 0.3);
      case ShimmerDirection.ttb:
        return const Alignment(0.3, 1.0);
      case ShimmerDirection.btt:
        return const Alignment(0.3, -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.baseColor,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
      builder: (context, placeholder) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.4, 0.5, 0.6],
              begin: _getBegin(widget.direction),
              end: _getEnd(widget.direction),
              transform: _ShimmerGradientTransform(
                slidePercent: _controller.value,
                direction: widget.direction,
              ),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: placeholder,
        );
      },
    );
  }
}

class _ShimmerGradientTransform extends GradientTransform {
  const _ShimmerGradientTransform({
    required this.slidePercent,
    required this.direction,
  });
  final double slidePercent;
  final ShimmerDirection direction;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final double ltrTtbMovement = (slidePercent - 0.5);
    double dx = 0.0;
    double dy = 0.0;

    switch (direction) {
      case ShimmerDirection.ltr:
      case ShimmerDirection.rtl:
        dx = ltrTtbMovement * bounds.width;
        break;
      case ShimmerDirection.ttb:
      case ShimmerDirection.btt:
        dy = ltrTtbMovement * bounds.height;
        break;
    }
    return Matrix4.translationValues(dx, dy, 0.0);
  }
}
