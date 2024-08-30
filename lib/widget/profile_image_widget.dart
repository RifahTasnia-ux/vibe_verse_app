import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String storyImagePath;
  final String profileDpPath;

  const ProfileImageWidget({
    super.key,
    required this.storyImagePath,
    required this.profileDpPath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          child: CachedNetworkImage(
            width: 96,
            height: 128,
            fit: BoxFit.cover,
            imageUrl: storyImagePath,
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
            child: Container(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  imageUrl: profileDpPath,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
