import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/svg_string.dart';



class PhotoPickerDialog extends StatelessWidget {
  final Function(ImageSource) onImageSelected;

  const PhotoPickerDialog({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenSize.width * 0.7,
        height: 240.0,
        padding: const EdgeInsets.only(top: 20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.string(
              SvgStringName.svgText,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.string(
                    SvgStringName.svgCamera,
                  ),
                  onPressed: () {
                    onImageSelected(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: SvgPicture.string(
                    SvgStringName.svgGallery,
                  ),
                  onPressed: () {
                    onImageSelected(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
