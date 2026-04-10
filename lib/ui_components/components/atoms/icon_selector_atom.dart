import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class IconSelectorAtom extends StatefulWidget {
  final Function(String)? onEmojiSelected;
  final String? currentEmoji;

  const IconSelectorAtom({super.key, this.onEmojiSelected, this.currentEmoji});

  @override
  State<IconSelectorAtom> createState() => _IconSelectorAtomState();
}

class _IconSelectorAtomState extends State<IconSelectorAtom> {
  String _selectedEmoji = '';

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.currentEmoji ?? '';
  }

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF444444),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            children: [
              EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  Navigator.pop(context);
                  setState(() => _selectedEmoji = emoji.emoji);
                  widget.onEmojiSelected!(emoji.emoji);
                },
                onBackspacePressed: () {},
                config: Config(
                    bottomActionBarConfig: BottomActionBarConfig(enabled: false),
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
                      backgroundColor: const Color(0xFF444444),
                      columns: 8,
                    ),
                    categoryViewConfig: const CategoryViewConfig(
                      backgroundColor: Color(0xFF444444),
                      categoryIcons: CategoryIcons(),
                    ),
                    searchViewConfig: SearchViewConfig(
                      backgroundColor: Colors.transparent,
                      buttonIconColor: Colors.transparent,
                    )),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back', style: TextStyle(color: AppColors.white)),
          ),
          TextButton(
            onPressed: () {
              widget.onEmojiSelected!('');
              setState(() => _selectedEmoji = '');
              Navigator.pop(context);
            },
            child: Text('Remove Emoji', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEmojiPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF343537),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(_selectedEmoji, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
