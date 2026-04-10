import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/page_settings_config/model/gradient_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientSelectorAtom extends StatefulWidget {
  final GradientSettingsModel initialData;
  final void Function(GradientSettingsModel)? onDataChanged;
  final EdgeInsets outerPadding;

  const GradientSelectorAtom({
    super.key,
    required this.initialData,
    this.onDataChanged,
    this.outerPadding = const EdgeInsets.all(16),
  });

  @override
  State<GradientSelectorAtom> createState() => _GradientSelectorAtomState();
}

class _GradientSelectorAtomState extends State<GradientSelectorAtom> {
  late GradientSettingsModel selectedData;

  @override
  void initState() {
    super.initState();
    selectedData = widget.initialData;
  }

  @override
  void didUpdateWidget(covariant GradientSelectorAtom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData) {
      setState(() {
        selectedData = widget.initialData;
      });
    }
  }

  void _pickGradient(BuildContext context) async {
    final newData = await showDialog<GradientSettingsModel>(
      context: context,
      builder: (context) => _GradientPickerDialog(initialData: selectedData),
    );

    if (newData != null && newData != selectedData) {
      setState(() {
        selectedData = newData;
      });
      widget.onDataChanged?.call(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = selectedData.gradientColors?.map((color) => color.toColor).toList();
    return GestureDetector(
      onTap: () => _pickGradient(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CustomPaint(
              painter: _CheckerBoardPainter(),
              size: Size(48, 48),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors == null || colors.isEmpty ? Colors.transparent : null,
                gradient: colors != null && colors.length >= 2
                    ? LinearGradient(
                        colors: colors,
                        begin: _getAlignment(selectedData.begin ?? 'topCenter'),
                        end: _getAlignment(selectedData.end ?? 'bottomCenter'),
                      )
                    : null,
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: const Icon(Icons.palette_outlined, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _getAlignment(String alignment) {
    switch (alignment) {
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      default:
        return Alignment.topCenter;
    }
  }
}

class _GradientPickerDialog extends StatefulWidget {
  final GradientSettingsModel initialData;
  const _GradientPickerDialog({required this.initialData});

  @override
  State<_GradientPickerDialog> createState() => _GradientPickerDialogState();
}

class _GradientPickerDialogState extends State<_GradientPickerDialog> {
  late List<Color> _gradientColors;
  late String _gradientBegin;
  late String _gradientEnd;
  int _selectedColorIndex = 0;

  static const Map<String, String> alignmentOptions = {
    'topLeft': 'Top Left',
    'topCenter': 'Top Center',
    'topRight': 'Top Right',
    'centerLeft': 'Center Left',
    'center': 'Center',
    'centerRight': 'Center Right',
    'bottomLeft': 'Bottom Left',
    'bottomCenter': 'Bottom Center',
    'bottomRight': 'Bottom Right',
  };

  @override
  void initState() {
    super.initState();
    _gradientColors =
        widget.initialData.gradientColors?.map((color) => color.toColor).toList() ?? [Colors.blue, Colors.red];
    _gradientBegin = widget.initialData.begin ?? 'topCenter';
    _gradientEnd = widget.initialData.end ?? 'bottomCenter';

    if (_gradientColors.length < 2) {
      _gradientColors = [Colors.blue, Colors.red];
    }
  }

  void _updateColor(Color newColor) {
    setState(() {
      _gradientColors[_selectedColorIndex] = newColor;
    });
  }

  void _addColor() {
    final startColor = _gradientColors[_selectedColorIndex];
    final endColor = (_selectedColorIndex == _gradientColors.length - 1)
        ? _gradientColors[0]
        : _gradientColors[_selectedColorIndex + 1];

    final newColor = Color.lerp(startColor, endColor, 0.5)!;
    final insertIndex = _selectedColorIndex + 1;

    setState(() {
      _gradientColors.insert(insertIndex, newColor);
      _selectedColorIndex = insertIndex;
    });
  }

  void _removeColor() {
    if (_gradientColors.length > 2) {
      setState(() {
        _gradientColors.removeAt(_selectedColorIndex);
        if (_selectedColorIndex >= _gradientColors.length) {
          _selectedColorIndex = _gradientColors.length - 1;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gradient must have at least 2 colors."),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      title: const Text("Select a gradient", style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 600,
        height: 500,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: double.infinity,
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: _gradientColors,
                  begin: BasicAlignmentType.fromModel(_gradientBegin),
                  end: BasicAlignmentType.fromModel(_gradientEnd),
                ),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Colors", style: TextStyle(color: Colors.white70)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                          onPressed: _addColor,
                          tooltip: 'Add interpolated color',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (int i = 0; i < _gradientColors.length; i++)
                          GestureDetector(
                            onTap: () => setState(() => _selectedColorIndex = i),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _gradientColors[i],
                                shape: BoxShape.circle,
                                border: _selectedColorIndex == i
                                    ? Border.all(color: Colors.white, width: 3)
                                    : Border.all(color: Colors.white24, width: 1),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _buildAlignmentSelector(
                      label: "Begin",
                      currentValue: _gradientBegin,
                      onChanged: (newAlignment) {
                        setState(() {
                          _gradientBegin = newAlignment;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildAlignmentSelector(
                      label: "End",
                      currentValue: _gradientEnd,
                      onChanged: (newAlignment) {
                        setState(() {
                          _gradientEnd = newAlignment;
                        });
                      },
                    ),
                    const Divider(color: Colors.white24, height: 30),
                    _ColorEditor(
                      key: ValueKey(_selectedColorIndex),
                      color: _gradientColors[_selectedColorIndex],
                      onColorChanged: _updateColor,
                      onRemove: _gradientColors.length > 2 ? _removeColor : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final result = GradientSettingsModel(
              gradientColors: _gradientColors.map((color) => color.toHexString()).toList(),
              begin: _gradientBegin,
              end: _gradientEnd,
            );
            Navigator.pop(context, result);
          },
          child: const Text("Select", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildAlignmentSelector({
    required String label,
    required String currentValue,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF444444),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            dropdownColor: const Color(0xFF2E2E2E),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: alignmentOptions.entries.map<DropdownMenuItem<String>>((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ColorEditor extends StatefulWidget {
  final Color color;
  final void Function(Color) onColorChanged;
  final VoidCallback? onRemove;

  const _ColorEditor({
    super.key,
    required this.color,
    required this.onColorChanged,
    this.onRemove,
  });

  @override
  State<_ColorEditor> createState() => _ColorEditorState();
}

class _ColorEditorState extends State<_ColorEditor> {
  late Color _currentColor;
  late final TextEditingController _hexController;

  final List<Color> _availableColors = [
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.grey,
    Colors.black,
    Colors.white,
    Colors.lime,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
    _hexController = TextEditingController(text: _currentColor.toHexString());
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ColorEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateColor(widget.color, fromWidget: true);
    }
  }

  void _updateColor(Color newColor, {bool fromWidget = false}) {
    if (!mounted) return;
    setState(() {
      _currentColor = newColor;
      if (_hexController.text.toUpperCase() != newColor.toHexString().toUpperCase()) {
        _hexController.text = newColor.toHexString();
      }
    });
    if (!fromWidget) {
      widget.onColorChanged(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CustomPaint(painter: _CheckerBoardPainter(), size: Size(40, 40)),
                  Container(width: 40, height: 40, color: _currentColor),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _hexController,
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: '#AARRGGBB',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _hexController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Hex code copied!"), duration: Duration(seconds: 1)));
                    },
                  ),
                ),
                onChanged: (value) {
                  try {
                    final newColor = value.toColor;
                    widget.onColorChanged(newColor);
                  } catch (e) {}
                },
              ),
            ),
            if (widget.onRemove != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: widget.onRemove,
                tooltip: 'Remove Color',
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Opacity", style: TextStyle(color: Colors.white70)),
        Slider(
          value: _currentColor.opacity,
          activeColor: _currentColor,
          inactiveColor: Colors.grey,
          onChanged: (opacity) => _updateColor(_currentColor.withOpacity(opacity)),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: _availableColors.map((color) {
            final isSelected = _currentColor.red == color.red &&
                _currentColor.green == color.green &&
                _currentColor.blue == color.blue;
            return GestureDetector(
              onTap: () => _updateColor(color.withOpacity(_currentColor.opacity)),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : Border.all(color: Colors.white24, width: 1),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CheckerBoardPainter extends CustomPainter {
  final double squareSize;
  const _CheckerBoardPainter({this.squareSize = 6});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0xFFCCCCCC);
    final paint2 = Paint()..color = const Color(0xFFFFFFFF);

    for (var i = 0; i * squareSize < size.width; i++) {
      for (var j = 0; j * squareSize < size.height; j++) {
        final paint = (i + j) % 2 == 0 ? paint1 : paint2;
        canvas.drawRect(Rect.fromLTWH(i * squareSize, j * squareSize, squareSize, squareSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
