import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flox/feature/builder/configs/image_config/model/image_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flox/feature/builder/configs/page_settings_config/model/page_settings_model.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

@RoutePage()
class ExperienceHPage extends StatefulWidget {
  const ExperienceHPage({super.key});

  @override
  State<ExperienceHPage> createState() => _ExperienceHPageState();
}

class _ExperienceHPageState extends State<ExperienceHPage> {
  PageSettingsConfig pageSettingsConfig = PageSettingsConfig.fromModel(PageSettingsModel.sample());
  ButtonConfig buttonConfig = ButtonConfig.fromModel(ButtonModel.sample());
  ImageConfig imageConfig = ImageConfig.fromModel(ImageModel.sample());
  MultipleChoiceConfig multipleChoiceConfig = MultipleChoiceConfig.fromModel(MultipleChoiceModel.sample());
  TextFieldConfig textFieldConfig = TextFieldConfig.fromModel(TextFieldModel.sample());
  ProgressConfig progressStyleConfig = ProgressConfig.fromModel(ProgressModel.sample());

  Set<int> selectedIndexes = {};

  Timer? _textUpdateTimer;
  String _currentProgressText = "";
  int _currentVisibleStepIndex = -1;
  DateTime? _animationStartTime;
  bool _animationStarted = false;
  double _totalDurationSec = 0;
  late List<double> _cumulativeDurations;

  @override
  void initState() {
    super.initState();

    if (progressStyleConfig.progressValues.isNotEmpty) {
      _totalDurationSec = progressStyleConfig.progressValues.map((e) => e.duration).reduce((a, b) => a + b);
    } else {
      _totalDurationSec = 0;
    }

    _calculateCumulativeDurations();

    if (progressStyleConfig.progressValues.isNotEmpty) {
      _currentProgressText = progressStyleConfig.progressValues[0].text;
      _currentVisibleStepIndex = 0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startProgressAnimationAndTextUpdates();
        }
      });
    }
  }

  void _calculateCumulativeDurations() {
    _cumulativeDurations = [];
    double currentSum = 0.0;
    for (final config in progressStyleConfig.progressValues) {
      currentSum += (config.duration > 0 ? config.duration : 0);
      _cumulativeDurations.add(currentSum);
    }
  }

  void _startProgressAnimationAndTextUpdates() {
    if (_totalDurationSec <= 0) return;

    _animationStartTime = DateTime.now();
    setState(() {
      _animationStarted = true;
    });

    _textUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _animationStartTime == null) {
        timer.cancel();
        return;
      }

      final elapsedDuration = DateTime.now().difference(_animationStartTime!);
      final elapsedSeconds = elapsedDuration.inMilliseconds / 1000.0;

      int newStepIndex = -1;
      for (int i = 0; i < _cumulativeDurations.length; i++) {
        if (elapsedSeconds < _cumulativeDurations[i]) {
          newStepIndex = i;
          break;
        }
      }

      if (newStepIndex == -1 && elapsedSeconds >= _totalDurationSec && progressStyleConfig.progressValues.isNotEmpty) {
        newStepIndex = progressStyleConfig.progressValues.length - 1;
      }

      if (newStepIndex != -1 && newStepIndex != _currentVisibleStepIndex) {
        setState(() {
          _currentVisibleStepIndex = newStepIndex;
          _currentProgressText = progressStyleConfig.progressValues[newStepIndex].text;
        });
      }

      if (elapsedSeconds >= _totalDurationSec) {
        timer.cancel();
        if (mounted &&
            _currentVisibleStepIndex != progressStyleConfig.progressValues.length - 1 &&
            progressStyleConfig.progressValues.isNotEmpty) {
          setState(() {
            _currentVisibleStepIndex = progressStyleConfig.progressValues.length - 1;
            _currentProgressText = progressStyleConfig.progressValues.last.text;
          });
        }
        log("Progress animation finished.");
      }
    });
  }

  @override
  void dispose() {
    _textUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int animationDurationMs = (_totalDurationSec * 1000).toInt();

    final double targetPercent = _animationStarted ? 1.0 : 0.0;
    return Scaffold(
      backgroundColor: pageSettingsConfig.backgroundColor,
      body: Center(
        child: Container(
          height: 600,
          width: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(pageSettingsConfig.backgroundImage),
              fit: BoxFit.fitHeight,
            ),
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            physics: pageSettingsConfig.scrollable
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                const SizedBox(),

                /// Button
                Container(
                  height: 48,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: buttonConfig.buttonColor,
                  ),
                  child: Center(
                    child: Text(
                      buttonConfig.text,
                      style: TextStyle(color: buttonConfig.textColor),
                    ),
                  ),
                ),

                /// Multiple Choice
                SizedBox(
                  width: 350,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexes.contains(index);
                      final defaultValue = multipleChoiceConfig.defaultStyle;
                      final selectedValue = multipleChoiceConfig.selectedStyle;
                      final option = multipleChoiceConfig.optionValues[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected ? selectedIndexes.remove(index) : selectedIndexes.add(index);
                          });
                        },
                        child: Container(
                          height: 58,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              defaultValue.cornerRadius,
                            ),
                            color: isSelected ? selectedValue.backgroundColor : defaultValue.backgroundColor,
                          ),
                          child: Row(
                            children: [
                              Text(
                                option.leadingIcon,
                                style: TextStyle(
                                  fontWeight: isSelected ? selectedValue.fontWeight : defaultValue.fontWeight,
                                  fontSize: isSelected ? selectedValue.fontSize : defaultValue.fontSize,
                                  color: isSelected ? selectedValue.textColor : defaultValue.textColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                option.text,
                                style: TextStyle(
                                  fontWeight: isSelected ? selectedValue.fontWeight : defaultValue.fontWeight,
                                  fontSize: isSelected ? selectedValue.fontSize : defaultValue.fontSize,
                                  color: isSelected ? selectedValue.textColor : defaultValue.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemCount: multipleChoiceConfig.optionValues.length,
                  ),
                ),

                /// TextField
                Padding(
                  padding: textFieldConfig.padding,
                  child: TextField(
                    style: TextStyle(
                      fontSize: textFieldConfig.fontSize,
                      color: textFieldConfig.textColor,
                      fontWeight: textFieldConfig.fontWeight,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textFieldConfig.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(textFieldConfig.cornerRadius),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(textFieldConfig.cornerRadius),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(textFieldConfig.cornerRadius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// Progress Indicator
                if (progressStyleConfig.progressValues.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentProgressText,
                        style: TextStyle(
                          color: progressStyleConfig.textColor,
                          fontSize: progressStyleConfig.fontSize,
                          fontWeight: progressStyleConfig.fontWeight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        key: const ValueKey('main_progress_indicator'),
                        padding: EdgeInsets.zero,
                        percent: targetPercent,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: animationDurationMs > 0 ? animationDurationMs : 100,
                        lineHeight: progressStyleConfig.height,
                        barRadius: Radius.circular(progressStyleConfig.cornerRadius),
                        backgroundColor: progressStyleConfig.backgroundColor,
                        progressColor: Colors.green,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
