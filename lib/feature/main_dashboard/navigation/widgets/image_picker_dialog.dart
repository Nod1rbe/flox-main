import 'dart:typed_data';

import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerDialog extends StatefulWidget {
  final void Function(String imageUrl) onImageSelected;
  final List<String> initialImageUrls;

  const ImagePickerDialog({
    super.key,
    required this.onImageSelected,
    this.initialImageUrls = const [],
  });

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  bool isUploading = false;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    imageUrls.addAll(widget.initialImageUrls);
    _loadExistingImages();
  }

  Future<void> _loadExistingImages() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final username = user.email ?? 'unknown';

    try {
      final files = await Supabase.instance.client.storage
          .from('images')
          .list(path: username, searchOptions: const SearchOptions(limit: 100));

      final urls = files
          .where((file) => file.name.endsWith('.jpg') || file.name.endsWith('.png') || file.name.endsWith('.webp'))
          .map((file) => Supabase.instance.client.storage.from('images').getPublicUrl('$username/${file.name}'))
          .toList();

      setState(() => imageUrls.addAll(urls));
    } catch (e) {
      _showError('Rasmlarni yuklashda xato: $e');
    }
  }

  Future<Uint8List?> _compressImage(Uint8List imageBytes) async {
    int quality = 90, width = 1080, height = 1080;

    while (quality >= 10) {
      final compressed = await FlutterImageCompress.compressWithList(
        imageBytes,
        format: CompressFormat.webp,
        quality: quality,
        minWidth: width,
        minHeight: height,
      );

      if (compressed.lengthInBytes <= 250 * 1024) return compressed;

      quality -= 10;
      if (quality < 10 && width > 300) {
        width = (width * 0.9).round();
        height = (height * 0.9).round();
        quality = 90;
      }
    }
    return null;
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final imageBytes = await pickedFile.readAsBytes();

    setState(() {
      isUploading = true;
    });

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _showError('Foydalanuvchi tizimga kirmagan');
      return;
    }

    final username = user.email ?? 'unknown';
    final fileName = '$username/${DateTime.now().millisecondsSinceEpoch}.webp';

    try {
      final compressed = await _compressImage(imageBytes);
      if (compressed == null) {
        throw Exception('Rasmni 250KB dan kichik webp formatga o‘tkazib bo‘lmadi');
      }

      await Supabase.instance.client.storage.from('images').uploadBinary(
            fileName,
            compressed,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/webp',
            ),
          );

      final imageUrl = Supabase.instance.client.storage.from('images').getPublicUrl(fileName);

      setState(() => imageUrls.add(imageUrl));
      widget.onImageSelected.call(imageUrl);
      _showMessage("✅ Rasm webp formatda yuklandi");
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Xato: $e');
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> _selectImageFromUrl(String imageUrl) async {
    try {
      widget.onImageSelected.call(imageUrl);
      Navigator.of(context).pop();
    } catch (e) {
      _showError('Rasmni tanlashda xato: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String error) {
    debugPrint(error);
    _showMessage("❌ $error");
    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.defaultButtonBackground,
      title: const Text('Yuklangan Rasmlar', style: TextStyle(color: AppColors.white)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: imageUrls.isEmpty
            ? const Center(child: Text("Hozircha rasmlar yo‘q", style: TextStyle(color: AppColors.white)))
            : Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(
                  imageUrls.length,
                  (index) => GestureDetector(
                    onTap: () => _selectImageFromUrl(imageUrls[index]),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                      width: 100,
                      height: 100,
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Text(
                          "Xato",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: isUploading ? null : _pickAndUploadImage,
          child: Text(
            isUploading ? 'Yuklanmoqda...' : 'Rasm qo‘shish',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Yopish', style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
