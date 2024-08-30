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
          profileDpPath: UrlPath.sampleImageTwo,
          storyImagePath: UrlPath.sampleImageThree,
        ),
        StoryProfileCardWidget(
          name: "Miraz",
          profileDpPath: UrlPath.sampleImageFour,
          storyImagePath: UrlPath.sampleImageOne,
        ),
        StoryProfileCardWidget(
          name: "Riyad",
          profileDpPath: UrlPath.sampleImageThree,
          storyImagePath: UrlPath.sampleImageTwo,
        ),
        StoryProfileCardWidget(
          name: "Akib",
          profileDpPath: UrlPath.sampleImageOne,
          storyImagePath: UrlPath.sampleImageFour,
        ),
      ],
    );
  }
}
