import 'package:flox/ui_components/components/atoms/switch_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class SwitchMolecule extends StatefulWidget {
  final String name;
  final void Function(bool)? onChanged;
  final double fontSize;
  final bool initialValue;
  const SwitchMolecule({
    super.key,
    required this.name,
    this.fontSize = 18,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<SwitchMolecule> createState() => _SwitchMoleculeState();
}

class _SwitchMoleculeState extends State<SwitchMolecule> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextAtom(text: widget.name, fontSize: widget.fontSize),
        SwitchAtom(onChanged: widget.onChanged, initialValue: widget.initialValue),
      ],
    );
  }
}
