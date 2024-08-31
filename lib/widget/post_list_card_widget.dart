import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/svg_string.dart';

class PostListCardWidget extends StatelessWidget {
  final String profilePictureUrl;
  final String name;
  //final String email;
  final List<String> postImageUrls;
  final String location;
  final int comments;
  final String caption;

  const PostListCardWidget({
    super.key,
    required this.profilePictureUrl,
    required this.name,
   // required this.email,
    required this.postImageUrls,
    required this.location,
    required this.comments,
    required this.caption,
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
                const SizedBox(width: 10),
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
                      /*Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff475467),
                        ),
                      ),*/
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
            const SizedBox(height: 10),
            // PageView for image slider
            SizedBox(
              height: 250, // Adjust height as needed
              child: PageView.builder(
                itemCount: postImageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: postImageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.string(
                  SvgStringName.svgRedHeartIcon,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.string(
                        SvgStringName.svgCommentIcon,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 5),
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
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                caption,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
