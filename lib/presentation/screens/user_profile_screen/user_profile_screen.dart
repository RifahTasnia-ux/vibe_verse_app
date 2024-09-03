import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../data/firebase_firestore.dart';
import '../../../widget/profile_tab_view_widget.dart';
import '../../../widget/profile_status_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> userProfile = {};
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final FirebaseFireStore _firebaseFireStore = FirebaseFireStore();
  bool _isLoading = true;

  // Class-level variables for user profile data
  String fullName = "No Name";
  String userHandle = "@noUserName";
  String profilePictureUrl = "https://via.placeholder.com/150";
  String totalPost = "0";
  String following = "0";
  String follower = "0";

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
      await _fetchPosts(); // _fetchPosts will now correctly update totalPost
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
        fullName = userProfile['fullName'] ?? 'No Name';
        userHandle = '@${userProfile['userName']?.toLowerCase() ?? 'noUserName'}';
        profilePictureUrl = userProfile['profile'] ?? 'https://via.placeholder.com/150';
        following = userProfile['following']?.length.toString() ?? '0';
        follower = userProfile['followers']?.length.toString() ?? '0';
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await _firebaseFireStore.fetchPosts();

      final userId = userProfile['userId'];

      final userPosts = fetchedPosts.where((post) {
        final postUserId = post['userId'];
        return postUserId != null && postUserId == userId;
      }).toList();

      setState(() {
        posts = userPosts;
        totalPost = userPosts.length.toString();
        print("Total User Posts: $totalPost");
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  void _onRefresh() async {
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "My Profile",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Column(
          children: [
            ProfileStatusHeaderWidget(
              fullName: fullName,
              userHandle: userHandle,
              profilePictureUrl: profilePictureUrl,
              totalPost: totalPost,
              following: following,
              follower: follower,
            ),
            const SizedBox(height: 5),
            ProfileTabViewWidget(posts: posts),
          ],
        ),
      ),
    );
  }
}
