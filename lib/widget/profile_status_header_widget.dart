import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileStatusHeaderWidget extends StatelessWidget {
  const ProfileStatusHeaderWidget({
    super.key,
    required this.fullName,
    required this.userHandle,
    required this.profilePictureUrl,
    required this.totalPost,
    required this.following,
    required this.follower,
  });

  final String fullName;
  final String userHandle;
  final String profilePictureUrl;
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
                imageUrl: profilePictureUrl,
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
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userHandle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff475467),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusRow(totalPost, 'Post'),
                  _buildSeparator(),
                  _buildStatusRow(following, 'Following'),
                  _buildSeparator(),
                  _buildStatusRow(follower, 'Follower'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String count, String label) {
    return Row(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff475467),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return const Text(
      " • ",
      style: TextStyle(color: Color(0xffD0D5DD)),
    );
  }
}
