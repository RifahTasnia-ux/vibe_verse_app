import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/image_picker.dart';
import '../../../utils/svg_string.dart';

class NewPostScreen extends StatefulWidget {
  final File selectedImage;

  const NewPostScreen({super.key, required this.selectedImage});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _pickedImage;
  final ImagePickerService _imagePickerService = ImagePickerService();
  List<File> recentImages = []; // List to store recent images
  List<int> selectedIndices = []; // List to manage selected state of images
  bool _isMultipleSelect = false; // State to manage single/multiple selection

  @override
  void initState() {
    super.initState();
    _pickedImage = File(widget.selectedImage.path);
    _loadRecentImages(); // Load recent images on initialization
  }

  // Function to load recent images
  void _loadRecentImages() async {
    // Load recent images from a directory or a database
    // For this example, we use the selected image as the only recent image
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
        recentImages.add(pickedImage as File);
        _pickedImage = pickedImage as File; // Set picked image
      });
    }
  }

  void _toggleSelection(int index) {
    if (_isMultipleSelect) {
      setState(() {
        if (selectedIndices.contains(index)) {
          selectedIndices.remove(index);
        } else {
          selectedIndices.add(index);
        }
        // Show the last selected image when in multiple select mode
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

    // Navigate to the next screen with the selected images
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NextScreen(selectedImages: selectedImages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto-Medium",
          ),
        ),
        actions: [
            Text(
              "Next",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto-Medium",
              ),
            ),
          IconButton(
            icon: SvgPicture.string(
              SvgStringName.svgNext,
            ),
            onPressed: _handleNext,
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
                  aspectRatio: 1.5, // Adjust the aspect ratio based on your image
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      items: const [
                        DropdownMenuItem(
                          value: "Recent photos",
                          child: Text(
                            "Recent photos",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto-Medium",
                            ),
                          ),
                        ),
                        // Add other sources here if needed
                      ],
                      onChanged: (value) {
                        // Handle change
                      },
                      value: "Recent photos",
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isMultipleSelect = !_isMultipleSelect;
                    });
                  },
                  child: Text(
                    _isMultipleSelect ? "Single Select" : "Multiple Select",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto-Medium",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.0, // Make each child a square
              ),
              itemCount: recentImages.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndices.contains(index);
                return Stack(
                  children: [
                    Container(
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
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          _toggleSelection(index);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _pickImage('camera'),
            child: Text('Pick Image from Camera'),
          ),
          ElevatedButton(
            onPressed: () => _pickImage('gallery'),
            child: Text('Pick Image from Gallery'),
          ),
        ],
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final List<File> selectedImages;

  const NextScreen({super.key, required this.selectedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
      ),
      body: ListView.builder(
        itemCount: selectedImages.length,
        itemBuilder: (context, index) {
          return Image.file(
            selectedImages[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
