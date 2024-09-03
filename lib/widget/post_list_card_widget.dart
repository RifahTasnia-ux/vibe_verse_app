import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/svg_string.dart';

class PostListCardWidget extends StatefulWidget {
  final String profilePictureUrl;
  final String name;
  final String fullname;
  final List<String> postImageUrls;
  final String location;
  final int comments;
  final String caption;

  const PostListCardWidget({
    super.key,
    required this.profilePictureUrl,
    required this.name,
    required this.fullname,
    required this.postImageUrls,
    required this.location,
    required this.comments,
    required this.caption,
  });

  @override
  _PostListCardWidgetState createState() => _PostListCardWidgetState();
}

class _PostListCardWidgetState extends State<PostListCardWidget> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                    imageUrl: widget.profilePictureUrl,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: "Satoshi-Medium",
                        ),
                      ),
                      Text(
                        '@${widget.name}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff475467),
                          fontFamily: "Satoshi-Medium",
                        ),
                      ),
                      Text(
                        widget.location,
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
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.postImageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: widget.postImageUrls[index],
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
                      Text("${widget.comments} comments", style: const TextStyle(fontFamily: "Satoshi-Medium",)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                if (widget.postImageUrls.length > 1) ...[
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.postImageUrls.length,
                    effect: const WormEffect(
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      spacing: 4.0,
                      radius: 8.0,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                    ),
                  ),
                ],
                const Expanded(child: SizedBox()),
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
                widget.caption,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: "Satoshi-Medium",),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
