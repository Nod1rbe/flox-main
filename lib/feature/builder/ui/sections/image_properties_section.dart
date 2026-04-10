import 'dart:io';

import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/enums/ui_enums/basic_box_fit_type.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/molecules/drop_down_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePropertiesSection extends StatefulWidget {
  final void Function(String path) onImageChanged;
  final void Function(Alignment alignment) onAlignmentChanged;
  final void Function(double height) onHeightChanged;
  final void Function(double width) onWidthChanged;
  final void Function(double cornerRadius) onCornerRadiusChanged;
  final void Function(BoxFit fit) onFitChanged;
  final ImageConfig imageConfig;

  const ImagePropertiesSection({
    super.key,
    required this.onFitChanged,
    required this.onImageChanged,
    required this.onAlignmentChanged,
    required this.onHeightChanged,
    required this.onWidthChanged,
    required this.onCornerRadiusChanged,
    required this.imageConfig,
  });

  @override
  State<ImagePropertiesSection> createState() => _ImagePropertiesSectionState();
}

class _ImagePropertiesSectionState extends State<ImagePropertiesSection> {
  List<String> items = ['left', 'center', 'right'];
  List<String> fitItems = ['fill', 'contain', 'cover', 'none', 'scale down', 'fit width', 'fit height'];
  late String initialFitValue;
  late String initialValue;

  File? _imageFile;
  bool isUploading = false;
  final List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    initialValue = BasicAlignmentType.toModel(widget.imageConfig.alignment);
    initialFitValue = BasicBoxFitType.toModel(widget.imageConfig.fit);
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
      debugPrint('Rasmlarni yuklashda xato: $e');
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
      widget.onImageChanged.call(imageUrl);
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
      setState(() {
        _imageFile = null;
      });
      widget.onImageChanged.call(imageUrl);
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

  void _showImagesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  )),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextAtom(text: 'Image', fontSize: 16),
              InkWell(
                onTap: _showImagesDialog,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.defaultButtonBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _imageFile != null ? _imageFile!.path.split('/').last : 'Rasm tanlang',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          DropDownMolecule(
            name: 'Alignment',
            items: items,
            initialValue: initialValue,
            isPrimary: true,
            onChanged: (value) {
              switch (value) {
                case 'left':
                  widget.onAlignmentChanged.call(Alignment.centerLeft);
                  break;
                case 'center':
                  widget.onAlignmentChanged.call(Alignment.center);
                  break;
                case 'right':
                  widget.onAlignmentChanged.call(Alignment.centerRight);
                  break;
              }
            },
          ),
          SizedBox(height: 16),
          DropDownMolecule(
            name: 'Box fit',
            items: fitItems,
            initialValue: initialFitValue,
            isPrimary: true,
            onChanged: (value) {
              switch (value) {
                case 'fill':
                  widget.onFitChanged.call(BoxFit.fill);
                  break;
                case 'cover':
                  widget.onFitChanged.call(BoxFit.cover);
                  break;
                case 'contain':
                  widget.onFitChanged.call(BoxFit.contain);
                  break;
                case 'fit width':
                  widget.onFitChanged.call(BoxFit.fitWidth);
                  break;
                case 'fit height':
                  widget.onFitChanged.call(BoxFit.fitHeight);
                  break;
                case 'scale down':
                  widget.onFitChanged.call(BoxFit.scaleDown);
                  break;
                case 'none':
                  widget.onFitChanged.call(BoxFit.none);
                  break;
              }
            },
          ),
          SizedBox(height: 16),
          TextFieldWithLabelMolecule(
            padding: EdgeInsets.all(12),
            name: 'Height',
            currentValue: widget.imageConfig.height.toString(),
            backgroundColor: AppColors.defaultButtonBackground,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onHeightChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
          TextFieldWithLabelMolecule(
            padding: EdgeInsets.all(12),
            currentValue: widget.imageConfig.width.toString(),
            name: 'Width',
            backgroundColor: AppColors.defaultButtonBackground,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onWidthChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
          TextFieldWithLabelMolecule(
            padding: EdgeInsets.all(12),
            currentValue: widget.imageConfig.cornerRadius.toString(),
            backgroundColor: AppColors.defaultButtonBackground,
            name: 'Corner radius',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onCornerRadiusChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
        ],
      ),
    );
  }
}
