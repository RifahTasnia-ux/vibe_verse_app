import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/profile_list_view_card.dart';

class ProfileListViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const ProfileListViewWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final post = posts[index];
              print("total post number $post");
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: ProfileListViewCardWidget(
                  profilePictureUrl: post['profilePictureUrl'],
                  fullName: post['fullName'],
                  postImageUrls: List<String>.from(post['postImageUrls']),
                  location: post['location'],
                  comments: post['comments'],
                  caption: post['caption'],
                ),
              );
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }
}

