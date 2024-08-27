import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vibe_verse/utils/svg_string.dart';

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
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFd9e0f0),
                radius: 17.5,
                backgroundImage:
                    NetworkImage('https://wallpapers.com/images/featured/cool-profile-picture-87h46gcobjl5e4xu.jpg'),
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
                    child: SvgPicture.string(SvgStringName.svgMessageIcon),
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
