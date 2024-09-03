import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/svg_string.dart';

class ProfileListViewCardWidget extends StatelessWidget {
  final String profilePictureUrl;
  final String fullName;
  final String email;
  final List<String> postImageUrls;
  final String location;
  final int comments;
  final String caption;

  const ProfileListViewCardWidget({
    super.key,
    required this.profilePictureUrl,
    required this.fullName,
    required this.email,
    required this.postImageUrls,
    required this.location,
    required this.comments,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    print("Profile full name: $caption");
    return Card(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: "Satoshi-Medium",
                        ),
                      ),
                     Row(
                       children: [
                         const Text(
                           "1d",
                           style: TextStyle(
                             fontSize: 12,
                             color: Color(0xff475467),
                             fontFamily: "Satoshi-Medium",
                           ),
                         ),
                         _buildSeparator(),
                         SizedBox(
                           height: 15,
                           width: 15,
                           child: SvgPicture.asset("assets/svg/svg_earth.svg",),
                         ),
                       ],
                     )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.topRight, // Align to the top
                    child: GestureDetector(
                      onTap: () async {},
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: SvgPicture.string(SvgStringName.svgOptionIcon),
                      ),
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
                      Text("$comments comments",style: const TextStyle(fontFamily: "Satoshi-Medium",),),
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400,fontFamily: "Satoshi-Medium",),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSeparator() {
  return const Text(
    " • ",
    style: TextStyle(color: Color(0xffD0D5DD)),
  );
}
