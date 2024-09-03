import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/svg_string.dart';
import '../../../widget/alertdialogbox.dart';
import '../home_bottom_nav_bar.dart';
import 'location_search_screen.dart';

class UploadScreen extends StatefulWidget {
  final List<File> selectedImages;

  const UploadScreen({super.key, required this.selectedImages});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _selectedLocation;
  String _postMessage = '';
  int _currentPage = 0;

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
        _selectedLocation = selectedLocation;
      });
    }
  }

  void _removeLocation() {
    setState(() {
      _selectedLocation = null;
    });
  }

  void _showPostDialog() {
    showDialog(
      context: context,
      builder: (context) => PostDialog(
        selectedImages: widget.selectedImages,
        selectedLocation: _selectedLocation,
        postMessage: _postMessage,
      ),
    ).then((success) {
      if (mounted) {
        if (success == true) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersistentBottomNavBar(),
                ),
                    (route) => false,
              );
            }
          });
        }
      }
    });
  }
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        widget.selectedImages.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
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
            fontFamily: "Satoshi-Medium",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              _showPostDialog();
            },
            child: Row(
              children: [
                const Text(
                  'Post',
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
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
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
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Write a caption',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: "Satoshi-Medium",
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                _postMessage = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 45),
                _buildPageIndicator(),
              ],
            ),
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
                    fontFamily: "Satoshi-Medium",
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Divider(),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: () {},
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
                              fontFamily: "Satoshi-Medium",
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
            const Divider(),
          ],
        ),
      ),
    );
  }
}