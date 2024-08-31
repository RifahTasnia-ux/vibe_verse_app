import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vibe_verse/utils/svg_string.dart';
import 'package:vibe_verse/utils/url_path.dart';

import '../data/firebase_auth.dart';
import '../presentation/screens/auth/splash_screen.dart';

class HomeAppBarWidget extends StatefulWidget {
  const HomeAppBarWidget({super.key});

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              SizedBox(
                width: 35.0,
                height: 35.0,
                child: CachedNetworkImage(
                  imageUrl: UrlPath.sampleProfilePicture,
                  imageBuilder: (context, imageProvider) =>
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover),
                        ),
                      ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Vibe Verse'.toUpperCase(),
                    style: GoogleFonts.nerkoOne(
                        fontSize: 35,
                      color: const Color(0xff363636),
                      fontWeight: FontWeight.w700,),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()async{},
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFd9e0f0).withOpacity(0.8),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SvgPicture.string(SvgStringName.svgNotificationIcon),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: ()async{
                  await Authentication().signOutUser();
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const SplashScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFd9e0f0).withOpacity(0.8),                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SvgPicture.string(SvgStringName.svgLogOutIcon,height: 24,width: 24,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
