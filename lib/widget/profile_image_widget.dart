import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imagePath;
  final String profileImagePath;

  const ProfileImageWidget({
    super.key,
    required this.imagePath,
    required this.profileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imagePath,
            width: 96.0,
            height: 128.0,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6.0,
          left: 6.0,
          child: Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff4478FF),
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 15.0,
              backgroundImage: NetworkImage(profileImagePath),
            ),
          ),
        ),
      ],
    );
  }
}
