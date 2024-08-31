import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vibe_verse/widget/post_list_view_widget.dart';
import 'package:vibe_verse/widget/home_app_bar_widget.dart';
import 'package:vibe_verse/widget/home_story_widget.dart';
import '../../../data/firebase_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> posts = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final FirebaseFireStore _firebaseFireStore = FirebaseFireStore();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await _firebaseFireStore.fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      // Handle any errors
      print("Error fetching posts: $e");
    }
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
