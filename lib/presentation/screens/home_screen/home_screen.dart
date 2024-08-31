import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:vibe_verse/widget/post_list_view_widget.dart';
import 'package:vibe_verse/widget/home_app_bar_widget.dart';
import 'package:vibe_verse/widget/home_story_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> posts = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    final fetchedPosts = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        "profilePictureUrl": data['userProfile'],
        "name": data['userName'],
        "username": "@${data['userName']}",
        "postImageUrls": List<String>.from(data['imageUrls']),
        "location": data['location'],
        "caption": data['caption'],
        "comments": 0
      };
    }).toList();

    setState(() {
      posts = fetchedPosts;
    });
  }

  void _onRefresh() async {
    await _fetchPosts();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: HomeAppBarWidget(),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
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
      ),
    );
  }
}
