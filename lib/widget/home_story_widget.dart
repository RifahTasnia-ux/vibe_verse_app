import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/add_story_card_widget.dart';
import 'package:vibe_verse/widget/story_list_widget.dart';

class HomeStoryWidget extends StatelessWidget {
  const HomeStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AddStoryCardWidget(),
            StoryListWidget(),
          ],
        ),
      ),
    );
  }
}