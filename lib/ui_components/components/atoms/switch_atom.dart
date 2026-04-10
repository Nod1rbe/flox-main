import 'package:flutter/material.dart';

class SwitchAtom extends StatefulWidget {
  final bool initialValue;
  final void Function(bool)? onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final EdgeInsets outerPadding;

  const SwitchAtom({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.width = 54,
    this.height = 30,
    this.activeColor = const Color(0xFF657DE8),
    this.inactiveColor = const Color(0xFF444444),
    this.duration = const Duration(milliseconds: 200),
    this.outerPadding = EdgeInsets.zero,
  });

  @override
  State<SwitchAtom> createState() => _SwitchAtomState();
}

class _SwitchAtomState extends State<SwitchAtom> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  void toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
    widget.onChanged?.call(isOn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: GestureDetector(
        onTap: toggleSwitch,
        child: AnimatedContainer(
          duration: widget.duration,
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isOn ? widget.activeColor : widget.inactiveColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedAlign(
            duration: widget.duration,
            alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: widget.height - 8,
              height: widget.height - 8,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
