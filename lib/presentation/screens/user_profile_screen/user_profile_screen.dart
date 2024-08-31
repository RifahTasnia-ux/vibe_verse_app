import 'package:flutter/material.dart';

import '../../../widget/profile_grid_list_widget.dart';
import '../../../widget/profile_status_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String totalPost = "59";
  String following = "125";
  String follower = "850";

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
      body: Column(
        children: [
          ProfileStatusHeaderWidget(
              totalPost: totalPost, following: following, follower: follower),
          const SizedBox(height: 5,),
          const ProfileGridListWidget(),
        ],
      ),
    );
  }
}



