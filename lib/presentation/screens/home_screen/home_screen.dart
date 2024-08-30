import 'package:flutter/material.dart';
import 'package:vibe_verse/utils/url_path.dart';
import 'package:vibe_verse/widget/post_list_view_widget.dart';
import 'package:vibe_verse/widget/home_app_bar_widget.dart';
import 'package:vibe_verse/widget/home_story_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      "profilePictureUrl": UrlPath.sampleProfilePicture,
      "name": "Tamim Chowdhury",
      "username": "@tamimchowdhury109",
      "postImageUrl": UrlPath.sampleImageThree,
      "comments": 20
    },
    {
      "profilePictureUrl": UrlPath.sampleImageFour,
      "name": "Miraz Ahmed",
      "username": "@miraz6477",
      "postImageUrl": UrlPath.sampleImageOne,
      "comments": 15
    },
    {
      "profilePictureUrl": UrlPath.sampleImage,
      "name": "Atik Tanvir",
      "username": "@tanvir1125",
      "postImageUrl": UrlPath.sampleImageTwo,
      "comments": 11
    },
    {
      "profilePictureUrl": UrlPath.sampleImageThree,
      "name": "Soyod Adil Afik",
      "username": "@afik6412",
      "postImageUrl": UrlPath.sampleImageOne,
      "comments": 8
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: HomeAppBarWidget(),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              children: [
                HomeStoryWidget(),
                SizedBox(height: 2), // Space between the story and posts
              ],
            ),
          ),
          PostListView(posts: posts),
        ],
      ),
    );
  }
}
