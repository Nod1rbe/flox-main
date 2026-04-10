import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/text_style_google_font_extension.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/progress_config/cubit/progress_view_cubit.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressConfigWidget extends StatefulWidget {
  const ProgressConfigWidget({
    super.key,
    required this.config,
    required this.isSelected,
  });

  final ProgressConfig config;
  final bool isSelected;

  @override
  State<ProgressConfigWidget> createState() => _ProgressConfigWidgetState();
}

class _ProgressConfigWidgetState extends State<ProgressConfigWidget> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeAndRunAnimations();
  }

  void _initializeAndRunAnimations() {
    _controllers = widget.config.progressValues.map((progressValue) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (progressValue.duration * 1000).toInt()),
      );
    }).toList();

    for (int i = 0; i < _controllers.length - 1; i++) {
      _controllers[i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllers[i + 1].forward();
        }
      });
    }

    if (_controllers.isNotEmpty) {
      _controllers.first.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressConfigWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      for (final controller in _controllers) {
        controller.dispose();
      }
      _initializeAndRunAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgressViewCubit, ProgressViewState>(
      listener: (context, state) {
        debugPrint('ProgressConfig widget updated: ${state.config.toString()}');
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
              children: [
                ...widget.config.progressValues.asMap().entries.map((entry) {
                  final index = entry.key;
                  final progressValue = entry.value;
                  final controller = _controllers[index];

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final percent = controller.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  progressValue.text,
                                  style: TextStyle(
                                    color: widget.config.textColor,
                                    fontSize: widget.config.fontSize,
                                    fontWeight: widget.config.fontWeight,
                                  ).withGoogleFont(widget.config.fontFamily),
                                ),
                                if (widget.config.showIcon && percent >= 1.0)
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              percent: percent,
                              backgroundColor: widget.config.backgroundColor,
                              lineHeight: widget.config.height,
                              barRadius: Radius.circular(widget.config.cornerRadius),
                              progressColor: const Color(0xFF657DE8),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
