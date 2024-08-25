import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:vibe_verse/data/firebase_auth.dart';
import 'package:vibe_verse/presentation/screens/auth/landing_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(
              onTap: () async {

                //logout logic

                await Authentication().signOutUser();
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const LandingScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: const Text('HOme')),
        ),
      ),
    );
  }
}
