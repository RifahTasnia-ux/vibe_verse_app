import 'package:flutter/cupertino.dart';
import 'package:vibe_verse/widget/post_list_card_widget.dart';

class PostListView extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const PostListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final post = posts[index];
          return PostListCardWidget(
            profilePictureUrl: post['profilePictureUrl'],
            name: post['name'],
            fullname: post['fullName'],
            postImageUrls: List<String>.from(post['postImageUrls']),
            location: post['location'],
            comments: post['comments'],
            caption: post['caption'],
          );
        },
        childCount: posts.length,
      ),
    );
  }
}
