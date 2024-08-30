import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/url_path.dart';

class ProfileStatusHeaderWidget extends StatelessWidget {
  const ProfileStatusHeaderWidget({
    super.key,
    required this.totalPost,
    required this.following,
    required this.follower,
  });

  final String totalPost;
  final String following;
  final String follower;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: CachedNetworkImage(
                imageUrl: UrlPath.sampleProfilePicture,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tamim Chowdhury",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "@tamimchowdhury109",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff475467),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        totalPost,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Center(
                        child: Text(
                          "Post",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff475467),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Text(
                        " • ",
                        style: TextStyle(color: Color(0xffD0D5DD)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        following,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Center(
                        child: Text(
                          "Following",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff475467),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Text(
                        " • ",
                        style: TextStyle(color: Color(0xffD0D5DD)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        follower,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Center(
                        child: Text(
                          "Follower",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff475467),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}