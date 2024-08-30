import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibe_verse/utils/url_path.dart';

class AddStoryCardWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const AddStoryCardWidget({
    Key? key,
    this.imageUrl = 'https://via.placeholder.com/150',
    this.width = 96.0,
    this.height = 154.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF9F9FA),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  width: width,
                  height: height * 0.83, // 128/154 to maintain the original ratio
                  fit: BoxFit.cover,
                  imageUrl: UrlPath.sampleProfilePicture,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 3.0),
              const Expanded(
                child: Text(
                  "Create story",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            top: height * 0.45,
            child: Container(
              height: height * 0.37,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.32, // Adjust icon position based on dynamic height
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff163038),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
