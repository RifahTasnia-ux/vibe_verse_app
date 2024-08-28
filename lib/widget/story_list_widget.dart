import 'package:flutter/material.dart';
import 'package:vibe_verse/utils/url_path.dart';
import 'package:vibe_verse/widget/story_profile_card_widget.dart';

class StoryListWidget extends StatelessWidget {
  const StoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StoryProfileCardWidget(
          name: "Sakib",
          imagePath: UrlPath.sampleImageTwo,
          profileImagePath: UrlPath.sampleImage,
        ),
        StoryProfileCardWidget(
          name: "Miraz",
          imagePath: UrlPath.sampleImageOne,
          profileImagePath: UrlPath.sampleImageTwo,
        ),
        StoryProfileCardWidget(
          name: "Riyad",
          imagePath: UrlPath.sampleImageTwo,
          profileImagePath: UrlPath.sampleImageOne,
        ),
        StoryProfileCardWidget(
          name: "Riyad",
          imagePath: UrlPath.sampleImageThree,
          profileImagePath: UrlPath.sampleImageFour,
        ),
      ],
    );
  }
}
