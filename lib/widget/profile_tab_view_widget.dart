import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/profile_grid_view_widget.dart';
import 'package:vibe_verse/widget/profile_list_view_widget.dart';

import '../data/firebase_firestore.dart';

class ProfileTabViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  const ProfileTabViewWidget({
    super.key,
    required this.posts,
  });

  @override
  State<ProfileTabViewWidget> createState() => _ProfileTabViewWidgetState();
}

class _ProfileTabViewWidgetState extends State<ProfileTabViewWidget> {

  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic> userProfile = {};
  List<Map<String, dynamic>> otherUsersProfiles = [];
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
      final userId = userProfile['userId'];

      final userPosts = fetchedPosts.where((post) {
        final postUserId = post['userId'];
        return postUserId != null && postUserId == userId;
      }).toList();

      setState(() {
        posts = userPosts;
        var totalPost = userPosts.length.toString();
        print("Total User Posts: $totalPost");
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


  @override
  Widget build(BuildContext context) {
    List<String> postImageUrls = widget.posts
        .expand((post) => List<String>.from(post['postImageUrls']))
        .toList();
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: Color(0xff101828),
                indicatorWeight: 0.1,
                labelColor: Color(0xff101828),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_view),
                        SizedBox(width: 8),
                        Text(
                          "Grid view",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list),
                        SizedBox(width: 8),
                        Text(
                          "List view",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StaggeredGridWidget(postImageUrls: postImageUrls),
                    ProfileListViewWidget(posts: posts,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
