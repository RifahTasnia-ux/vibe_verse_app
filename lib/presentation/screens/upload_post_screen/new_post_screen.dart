import 'dart:io';
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
    _loadRecentImages(); // Load recent images on initialization
  }

  void _loadRecentImages() async {
    if (mounted) {
      setState(() {
        recentImages = [_pickedImage!]; // Add the selected image to recent images
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can only select up to 4 images.'),
              ),
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
    // Create the list of selected images
    List<File> selectedImages = _isMultipleSelect
        ? [for (int index in selectedIndices) recentImages[index]]
        : [_pickedImage!];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadScreen(selectedImages: selectedImages),
      ),
    );
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
            fontFamily: "Satoshi",
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
                    fontFamily: "Satoshi",
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
          // Selected Image Preview
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

          // Dropdown and Grid
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
                                  fontFamily: "Satoshi",
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
                              fontFamily: "Satoshi",
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
                        recentImages[index], // Display the recent image
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
          ElevatedButton(
            onPressed: () => _pickImage('camera'),
            child: const Text('Pick Image from Camera'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage('gallery'),
            child: const Text('Pick Image from Gallery'),
          ),
        ],
      ),
    );
  }
}
