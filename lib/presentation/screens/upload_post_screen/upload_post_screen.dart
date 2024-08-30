import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/svg_string.dart';
import '../../../widget/alertdialogbox.dart';
import 'location_search_screen.dart';


class UploadScreen extends StatefulWidget {
  final List<File> selectedImages;

  const UploadScreen({super.key, required this.selectedImages});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _selectedLocation;

  void _selectLocation() async {
    final selectedLocation = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const LocationSearchScreen(
          latitude: 0,
          longitude: 0,
        ),
      ),
    );

    if (selectedLocation != null && mounted) {
      setState(() {
        _selectedLocation = selectedLocation; // Store the most recent selected location
      });
    }
  }

  void _removeLocation() {
    setState(() {
      _selectedLocation = null;
    });
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
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const PostDialog(),
              );
            },
            child: Row(
              children: [
                const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedImages.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                    width: 150,
                    child: PageView.builder(
                      itemCount: widget.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                              image: FileImage(widget.selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: const SingleChildScrollView(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Write a caption',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Divider(),
            if (_selectedLocation != null) ...[
              ListTile(
                leading: SvgPicture.string(
                  SvgStringName.svgLocation,
                ),
                title: Text(_selectedLocation!),
                trailing: IconButton(
                  icon: SvgPicture.string(
                    SvgStringName.svgCross,
                  ),
                  onPressed: _removeLocation,
                ),
              ),
            ] else ...[
              TextButton(
                onPressed: _selectLocation,
                child: const Text(
                  'Add Location',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Divider(),
              Wrap(
                spacing: 8,
                children: List.generate(3, (index) {
                  return TextButton(
                    onPressed: () {
                      // Handle Multiple Select action
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Multiple Select',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ),
            ],
            const Divider(),
          ],
        ),
      ),
    );
  }
}
