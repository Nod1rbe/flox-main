import 'package:flox/ui_components/components/atoms/icon_selector_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class IconSelectorMolecule extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final String? initialEmoji;

  const IconSelectorMolecule({
    super.key,
    required this.onEmojiSelected,
    this.initialEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextAtom(
          text: 'Leading icon',
          fontSize: 16,
          padding: const EdgeInsets.only(left: 16, right: 24),
        ),
        IconSelectorAtom(
          onEmojiSelected: (emoji) => onEmojiSelected(emoji),
          currentEmoji: initialEmoji,
        ),
      ],
    );
  }
}
