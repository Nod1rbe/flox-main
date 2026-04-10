import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DropDownAtom extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final void Function(String)? onChanged;
  final EdgeInsets padding;
  final EdgeInsets outerPadding;

  const DropDownAtom({
    super.key,
    required this.items,
    required this.initialValue,
    this.onChanged,
    this.padding = const EdgeInsets.all(0),
    this.outerPadding = EdgeInsets.zero,
  });

  @override
  State<DropDownAtom> createState() => _DropDownAtomState();
}

class _DropDownAtomState extends State<DropDownAtom> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    assert(widget.items.contains(widget.initialValue), 'CustomDropdown initialValue must be inside items');
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
          value: _currentValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value!;
            });
            widget.onChanged?.call(value!);
          },
          items: widget.items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
          buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          )),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: AppColors.layoutBackground,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.defaultButtonBackground,
            contentPadding: widget.padding,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.defaultButtonBackground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.defaultButtonBackground),
            ),
          ),
          iconStyleData: const IconStyleData(
            iconEnabledColor: AppColors.white,
          ),
          style: const TextStyle(color: AppColors.white, fontSize: 16),
        ),
      ),
    );
  }
}
