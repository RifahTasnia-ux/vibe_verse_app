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
  Map<String, dynamic> userProfile = {};
  List<Map<String, dynamic>> otherUsersProfiles = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final FirebaseFireStore _firebaseFireStore = FirebaseFireStore();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _getUserProfile();
      await _fetchUserProfiles();
      await _fetchPosts();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getUserProfile() async {
    try {
      final fetchedUserProfile = await _firebaseFireStore.getUserProfile();
      setState(() {
        userProfile = fetchedUserProfile;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await _firebaseFireStore.fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> _fetchUserProfiles() async {
    try {
      final allUserProfiles = await _firebaseFireStore.getAllUserProfiles();
      final currentUserId = userProfile['userId'];

      setState(() {
        otherUsersProfiles = allUserProfiles
            .where((profile) => profile['userId'] != currentUserId)
            .toList();
      });
    } catch (e) {
      print("Error fetching user profiles: $e");
    }
  }

  void _onRefresh() async {
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: HomeAppBarWidget(
          profileImageUrl: userProfile['profile'] ?? 'https://via.placeholder.com/150',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeStoryWidget(
                    profileImageUrl: userProfile['profile'] ?? 'https://via.placeholder.com/150',
                    otherUsersProfiles: otherUsersProfiles,
                  ),
                  const SizedBox(height: 2),
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
