import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/progress_config/cubit/progress_view_cubit.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressValuesSection extends StatefulWidget {
  final Function(String, double) onAddProgressValue;
  final void Function(int index, {String? text, double? duration})? onProgressValueUpdated;
  final void Function(int index)? onProgressValueRemoved;

  const ProgressValuesSection({
    super.key,
    required this.onAddProgressValue,
    this.onProgressValueUpdated,
    this.onProgressValueRemoved,
  });

  @override
  State<ProgressValuesSection> createState() => _ProgressValuesSectionState();
}

class _ProgressValuesSectionState extends State<ProgressValuesSection> {
  final List<TextEditingController> _textControllers = [];
  final List<TextEditingController> _durationControllers = [];
  final List<FocusNode> _textFocusNodes = [];
  final List<FocusNode> _durationFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _syncControllersWithConfig(context.read<ProgressViewCubit>().state.config.progressValues);
  }

  @override
  void didUpdateWidget(ProgressValuesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _syncControllersWithConfig(List<dynamic> progressValues) {
    while (_textControllers.length < progressValues.length) {
      _textControllers.add(TextEditingController());
      _durationControllers.add(TextEditingController());
      _textFocusNodes.add(FocusNode());
      _durationFocusNodes.add(FocusNode());
    }

    while (_textControllers.length > progressValues.length) {
      _textControllers.removeLast().dispose();
      _durationControllers.removeLast().dispose();
      _textFocusNodes.removeLast().dispose();
      _durationFocusNodes.removeLast().dispose();
    }

    for (int i = 0; i < progressValues.length; i++) {
      final configText = progressValues[i].text ?? '';
      final configDuration = progressValues[i].duration.toString();

      if (!_textFocusNodes[i].hasFocus && _textControllers[i].text != configText) {
        _updateControllerValue(_textControllers[i], configText);
      }
      if (!_durationFocusNodes[i].hasFocus && _durationControllers[i].text != configDuration) {
        _updateControllerValue(_durationControllers[i], configDuration);
      }
    }
  }

  void _updateControllerValue(TextEditingController controller, String newText) {
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  @override
  void dispose() {
    for (var c in _textControllers) {
      c.dispose();
    }
    for (var c in _durationControllers) {
      c.dispose();
    }
    for (var f in _textFocusNodes) {
      f.dispose();
    }
    for (var f in _durationFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgressViewCubit, ProgressViewState>(
      listener: (context, state) {
        setState(() {
          _syncControllersWithConfig(state.config.progressValues);
        });
      },
      child: BlocBuilder<ProgressViewCubit, ProgressViewState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextAtom(text: 'Progress Values', fontSize: 24),
                const SizedBox(height: 16),
                ...List.generate(_textControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.defaultButtonBackground,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                                onPressed: () => widget.onProgressValueRemoved?.call(index),
                              ),
                            ],
                          ),
                          TextFieldAtom(
                            controller: _textControllers[index],
                            focusNode: _textFocusNodes[index],
                            onChanged: (value) {
                              widget.onProgressValueUpdated?.call(index, text: value);
                            },
                            fillColor: AppColors.layoutBackground,
                          ),
                          const SizedBox(height: 16),
                          TextFieldWithLabelMolecule(
                            backgroundColor: AppColors.layoutBackground,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                            currentValue: _durationControllers[index].text,
                            controller: _durationControllers[index],
                            focusNode: _durationFocusNodes[index],
                            defaultSize: 76,
                            name: 'Duration in sec.',
                            onChanged: (value) {
                              final parsedValue = double.tryParse(value);
                              if (parsedValue != null) {
                                widget.onProgressValueUpdated?.call(index, duration: parsedValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    widget.onAddProgressValue('New Step', 1.0);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.defaultButtonBackground,
                    ),
                    child: const Center(
                      child: Text('Add Progress', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
