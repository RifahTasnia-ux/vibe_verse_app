import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/add_story_card_widget.dart';
import 'package:vibe_verse/widget/story_profile_card_widget.dart';

class HomeStoryWidget extends StatelessWidget {
  final String profileImageUrl;
  final List<Map<String, dynamic>> otherUsersProfiles;

  const HomeStoryWidget({
    Key? key,
    required this.profileImageUrl,
    required this.otherUsersProfiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AddStoryCardWidget(imageUrl: profileImageUrl),
            ...otherUsersProfiles.map((profile) {
              return StoryProfileCardWidget(
                name: profile['fullName'] ?? 'Unknown',
                profileDpPath: profileImageUrl,
                storyImagePath: profile['profile'] ?? 'https://via.placeholder.com/150',
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
