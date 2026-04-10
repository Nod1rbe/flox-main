import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/mc_option_values_config.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/icon_selector_molecule.dart';
import 'package:flutter/material.dart';

class McOptionValuesSection extends StatefulWidget {
  final Function(String, String) onAddOption;
  final void Function(int index, {String? text, String? leadingIcon})? onOptionUpdated;
  final void Function(int index)? onOptionRemoved;
  final List<McOptionValuesConfig> optionValues;

  const McOptionValuesSection({
    super.key,
    required this.onAddOption,
    required this.optionValues,
    this.onOptionUpdated,
    this.onOptionRemoved,
  });

  @override
  State<McOptionValuesSection> createState() => _McOptionValuesSectionState();
}

class _McOptionValuesSectionState extends State<McOptionValuesSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextAtom(text: 'Option Values', fontSize: 24),
          const SizedBox(height: 16),
          ...List.generate(widget.optionValues.length, (index) {
            final option = widget.optionValues[index];
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
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                          onPressed: () => widget.onOptionRemoved?.call(index),
                        ),
                      ],
                    ),
                    TextFieldAtom(
                      initialValue: option.text,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        widget.onOptionUpdated?.call(index, text: value);
                      },
                      fillColor: AppColors.layoutBackground,
                    ),
                    const SizedBox(height: 16),
                    IconSelectorMolecule(
                      initialEmoji: option.leadingIcon,
                      onEmojiSelected: (emoji) {
                        widget.onOptionUpdated?.call(index, leadingIcon: emoji);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () {
              widget.onAddOption('New Option', '');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.defaultButtonBackground,
              ),
              child: const Center(
                child: Text(
                  'Add Option',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
