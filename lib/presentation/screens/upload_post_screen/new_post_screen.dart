import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibe_verse/presentation/screens/upload_post_screen/upload_post_screen.dart';

import '../../../utils/image_picker.dart';
import '../../../utils/svg_string.dart';

class NewPostScreen extends StatefulWidget {
  final File selectedImage;

  const NewPostScreen({super.key, required this.selectedImage});

  @override
  NewPostScreenState createState() => NewPostScreenState();
}

class NewPostScreenState extends State<NewPostScreen> {
  File? _pickedImage;
  final ImagePickerService _imagePickerService = ImagePickerService();
  List<File> recentImages = [];
  List<int> selectedIndices = [];
  bool _isMultipleSelect = false;
  final int maxSelection = 4;

  @override
  void initState() {
    super.initState();
    _pickedImage = File(widget.selectedImage.path);
    _loadRecentImages();
  }

  void _loadRecentImages() async {
    if (mounted) {
      setState(() {
        recentImages = [_pickedImage!];
      });
    }
  }

  Future<void> _pickImage(String source) async {
    final pickedImage = await _imagePickerService.uploadImage(source);
    if (pickedImage != null && mounted) {
      setState(() {
        recentImages.add(pickedImage);
        _pickedImage = pickedImage;
      });
    }
  }

  void _toggleSelection(int index) {
    if (_isMultipleSelect) {
      setState(() {
        if (selectedIndices.contains(index)) {
          selectedIndices.remove(index);
        } else {
          if (selectedIndices.length < maxSelection) {
            selectedIndices.add(index);
          } else {
            _showFlushbar(
              'You can only select up to 4 images !',
              Colors.blueAccent,
            );
          }
        }
        if (selectedIndices.isNotEmpty) {
          _pickedImage = recentImages[selectedIndices.last];
        }
      });
    } else {
      setState(() {
        _pickedImage = recentImages[index];
        selectedIndices = [index];
      });
    }
  }

  void _handleNext() {
    List<File> selectedImages = _isMultipleSelect
        ? [for (int index in selectedIndices) recentImages[index]]
        : [_pickedImage!];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadScreen(selectedImages: selectedImages),
      ),
    );
  }
  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: SvgPicture.string(
            SvgStringName.svgBack,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "New Post",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "Satoshi-Medium",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _handleNext();
            },
            child: Row(
              children: [
                const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Satoshi-Medium",
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.string(
                  SvgStringName.svgNext,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_pickedImage != null) ...[
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(
                    _pickedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButton<String>(
                          items: const [
                            DropdownMenuItem(
                              value: "Recent photos",
                              child: Text(
                                "Recent photos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Satoshi-Medium",
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {},
                          value: "Recent photos",
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
                const SizedBox(width: 7.0),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isMultipleSelect = !_isMultipleSelect;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.string(
                            SvgStringName.svgClip,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _isMultipleSelect ? "Single Select" : "Multiple Select",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Satoshi-Medium",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.0,
              ),
              itemCount: recentImages.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndices.contains(index);
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        recentImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: GestureDetector(
                        onTap: () => _toggleSelection(index),
                        child: Icon(
                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          color: isSelected ? Colors.blue : Colors.grey,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              "Select More Images to Post",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Satoshi-Medium",
                color: Colors.blueAccent,
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () => _pickImage('camera'),
            child: const Text('Pick Image from Camera',style: TextStyle(color: Colors.purple),),
          ),
          ElevatedButton(
            onPressed: () => _pickImage('gallery'),
            child: const Text('Pick Image from Gallery',style: TextStyle(color: Colors.purple),),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
