import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class TextMolecule extends StatelessWidget {
  final String name1;
  final String name2;
  final EdgeInsets padding;
  final Color color;

  const TextMolecule({
    super.key,
    required this.name1,
    required this.name2,
    this.color = Colors.blueAccent,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextAtom(
              text: name1,
              padding: EdgeInsets.all(12),
            ),
            TextAtom(
              text: name2,
              padding: EdgeInsets.all(12),
            ),
          ],
        ),
      ),
    );
  }
}
