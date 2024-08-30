import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/svg_string.dart';

class PostListCardWidget extends StatelessWidget {
  final String profilePictureUrl;
  final String name;
  final String username;
  final String postImageUrl;
  final int comments;

  const PostListCardWidget({
    super.key,
    required this.profilePictureUrl,
    required this.name,
    required this.username,
    required this.postImageUrl,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageUrl: profilePictureUrl,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff475467),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFd9e0f0).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: SvgPicture.string(SvgStringName.svgNotificationIcon),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Set your desired radius
              child: CachedNetworkImage(
                imageUrl: postImageUrl,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.string(
                  SvgStringName.svgRedHeartIcon,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.string(
                        SvgStringName.svgCommentIcon,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("$comments comments"),
                    ],
                  ),
                ),
                SvgPicture.string(
                  SvgStringName.svgSavedIcon,
                  height: 24,
                  width: 24,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
