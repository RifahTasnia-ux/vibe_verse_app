import 'package:flutter/material.dart';
import 'package:vibe_verse/utils/url_path.dart';

class HomeStoryWidget extends StatelessWidget {
  const HomeStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Positioned(
              top: 25,
              left: 25,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  profileCard("You", UrlPath.sampleImage, UrlPath.sampleImageOne),
                  const Positioned(
                    top: 50,
                    child: Icon(
                      Icons.add, // Plus icon
                      size: 35,
                      color: Colors.white, // Icon color
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                profileCard("Sakib", UrlPath.sampleImageTwo, UrlPath.sampleImage),
                profileCard("Miraz", UrlPath.sampleImageOne, UrlPath.sampleImageTwo),
                profileCard("Riyad", UrlPath.sampleImageTwo, UrlPath.sampleImageOne),
                profileCard("Riyad", UrlPath.sampleImageThree, UrlPath.sampleImageFour)
              ],
            )
          ]
        ),
      ),
    );
  }

  Widget profileCard(String name, String imagePath, String profileImagePath,) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 96.0,
        height: 154.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffF9F9FA),
          border: Border.all(color: Color(0xffEAECF0),)
        ),
        child: Column(
          children: [
            Stack(
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
                    width: 30.0,  // Width and height should match the diameter of the CircleAvatar
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff4478FF), // Border color
                        width: 2.0,          // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(profileImagePath),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
