import 'package:flutter/material.dart';
import 'package:vibe_verse/utils/url_path.dart';
import 'package:vibe_verse/widget/story_profile_card_widget.dart';

class AddStoryCardWidget extends StatelessWidget {
  const AddStoryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        StoryProfileCardWidget(
          name: "You",
          imagePath: UrlPath.sampleImage,
          profileImagePath: UrlPath.sampleImageOne,
        ),
        const Positioned(
          top: 50,
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}


