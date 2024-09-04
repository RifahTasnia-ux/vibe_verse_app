import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/svg_string.dart';

class ProfileListViewCardWidget extends StatefulWidget {
  final String profilePictureUrl;
  final String fullName;
  final List<String> postImageUrls;
  final String location;
  final int comments;
  final String caption;

  const ProfileListViewCardWidget({
    super.key,
    required this.profilePictureUrl,
    required this.fullName,
    required this.postImageUrls,
    required this.location,
    required this.comments,
    required this.caption,
  });

  @override
  _ProfileListViewCardWidgetState createState() =>
      _ProfileListViewCardWidgetState();
}

class _ProfileListViewCardWidgetState extends State<ProfileListViewCardWidget> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
                    imageUrl: widget.profilePictureUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName,
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
                            child: SvgPicture.asset("assets/svg/svg_earth.svg"),
                          ),
                        ],
                      ),
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
            Column(
              children: [
                SizedBox(
                  height: 250, // Adjust height as needed
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.postImageUrls.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.postImageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ],
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
                Row(
                  children: [
                    SvgPicture.string(
                      SvgStringName.svgCommentIcon,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.comments} comments",
                      style: const TextStyle(fontFamily: "Satoshi-Medium"),
                    ),
                  ],
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Satoshi-Medium",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Text(
      " • ",
      style: TextStyle(color: Color(0xffD0D5DD)),
    );
  }
}
