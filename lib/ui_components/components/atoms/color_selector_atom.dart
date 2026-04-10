import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorSelectorAtom extends StatefulWidget {
  final Color initialColor;
  final void Function(Color)? onColorChanged;
  final EdgeInsets outerPadding;

  const ColorSelectorAtom({
    super.key,
    required this.initialColor,
    this.onColorChanged,
    this.outerPadding = const EdgeInsets.all(16),
  });

  @override
  State<ColorSelectorAtom> createState() => _ColorSelectorAtomState();
}

class _ColorSelectorAtomState extends State<ColorSelectorAtom> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  void didUpdateWidget(covariant ColorSelectorAtom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      setState(() {
        selectedColor = widget.initialColor;
      });
    }
  }

  void _pickColor(BuildContext context) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorPickerDialog(initialColor: selectedColor),
    );

    if (newColor != null && newColor != selectedColor) {
      setState(() {
        selectedColor = newColor;
      });
      widget.onColorChanged?.call(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: GestureDetector(
        onTap: () => _pickColor(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const CustomPaint(
                painter: _CheckerBoardPainter(),
                size: Size(48, 48),
              ),
              Container(width: 48, height: 48, color: selectedColor),
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
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
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
    _currentColor = widget.initialColor;
    _hexController = TextEditingController(text: _currentColor.toHexString());
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _updateColor(Color newColor) {
    setState(() {
      _currentColor = newColor;
      _hexController.text = newColor.toHexString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      title: const Text("Select a color", style: TextStyle(color: Colors.white)),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
                      final newColor = value.toColor;
                      setState(() => _currentColor = newColor);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Opacity", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
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
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
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
          onPressed: () => Navigator.pop(context, _currentColor),
          child: const Text("Select", style: TextStyle(color: Colors.white)),
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
