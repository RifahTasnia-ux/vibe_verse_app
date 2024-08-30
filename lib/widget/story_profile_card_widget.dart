import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/profile_image_widget.dart';

class StoryProfileCardWidget extends StatelessWidget {
  final String name;
  final String profileDpPath;
  final String storyImagePath;

  const StoryProfileCardWidget({
    super.key,
    required this.name,
    required this.profileDpPath,
    required this.storyImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 96.0,
      height: 154.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF9F9FA),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Column(
        children: [
          ProfileImageWidget(profileDpPath: profileDpPath, storyImagePath: storyImagePath,),
          const SizedBox(height: 3.0),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }
}
