import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AnalyticsFieldsSection extends StatefulWidget {
  final void Function(String name) onAnalyticsFieldChanged;
  final String value;

  const AnalyticsFieldsSection({super.key, required this.onAnalyticsFieldChanged, required this.value});

  @override
  State<AnalyticsFieldsSection> createState() => _AnalyticsFieldsSectionState();
}

class _AnalyticsFieldsSectionState extends State<AnalyticsFieldsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics Fields Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.white),
          ),
          const SizedBox(height: 16),
          TextFieldAtom(
            controller: _controller,
            onChanged: widget.onAnalyticsFieldChanged,
            fillColor: AppColors.pageBackground.withAlpha(0xCC),
            hintText: 'Enter analytics fields name',
          )
        ],
      ),
    );
  }
}
