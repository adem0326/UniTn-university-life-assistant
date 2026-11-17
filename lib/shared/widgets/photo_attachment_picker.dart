import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';

class PhotoAttachmentPicker extends StatefulWidget {
  const PhotoAttachmentPicker({super.key, this.onChanged});

  final ValueChanged<XFile?>? onChanged;

  @override
  State<PhotoAttachmentPicker> createState() => _PhotoAttachmentPickerState();
}

class _PhotoAttachmentPickerState extends State<PhotoAttachmentPicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _photo;
  Uint8List? _photoBytes;

  @override
  Widget build(BuildContext context) {
    final photoBytes = _photoBytes;
    if (photoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 176,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(photoBytes, fit: BoxFit.cover),
              Positioned(
                left: 8,
                bottom: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      _photo?.name ?? 'Selected photo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.surface,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton.filled(
                  key: const Key('remove_attached_photo'),
                  tooltip: 'Remove photo',
                  onPressed: _removePhoto,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      key: const Key('add_photo_button'),
      onPressed: _showPhotoSourceOptions,
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('Add a photo'),
    );
  }

  Future<void> _showPhotoSourceOptions() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      useSafeArea: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final photo = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photo = photo;
        _photoBytes = bytes;
      });
      widget.onChanged?.call(photo);
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not access the selected photo.')),
      );
    }
  }

  void _removePhoto() {
    setState(() {
      _photo = null;
      _photoBytes = null;
    });
    widget.onChanged?.call(null);
  }
}
