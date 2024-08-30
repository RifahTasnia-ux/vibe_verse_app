import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibe_verse/presentation/screens/search_screen/search_screen.dart';
import 'package:vibe_verse/presentation/screens/upload_post_screen/new_post_screen.dart';
import 'package:vibe_verse/presentation/screens/upload_post_screen/upload_post_screen.dart';
import 'package:vibe_verse/presentation/screens/user_profile_screen/user_profile_screen.dart';
import 'package:vibe_verse/utils/svg_string.dart';

import '../../utils/image_picker.dart';
import '../../widget/photodialogbox.dart';
import 'home_screen/home_screen.dart';

class PersistentBottomNavBar extends StatefulWidget {
  const PersistentBottomNavBar({super.key});

  @override
  _PersistentBottomNavBarState createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
      SearchScreen(),
      Placeholder(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.string(SvgStringName.svgHomeSelected, height: 24, width: 24),
        inactiveIcon: SvgPicture.string(SvgStringName.svgHomeIcon, height: 24, width: 24),
        activeColorPrimary: const Color(0xff4478FF),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.string(SvgStringName.svgSearchIconSelected, height: 24, width: 24),
        inactiveIcon: SvgPicture.string(SvgStringName.svgSearchIcon, height: 24, width: 24),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.string(SvgStringName.svgAddIconSelected, height: 24, width: 24),
        inactiveIcon: SvgPicture.string(SvgStringName.svgAddIcon, height: 24, width: 24),
        activeColorPrimary: const Color(0xff4478FF),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.string(SvgStringName.svgProfileIconSelected,height: 24,width: 24,),
        inactiveIcon: SvgPicture.string(SvgStringName.svgProfileIcon,height: 24,width: 24,),
        // title: "Profile",
        activeColorPrimary: const Color(0xff4478FF),
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhotoPickerDialog(
          onImageSelected: (ImageSource source) async {
            final imagePickerService = ImagePickerService();
            final pickedImage = await imagePickerService.uploadImage(source == ImageSource.camera ? 'camera' : 'gallery');
            if (pickedImage != null) {
              if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(selectedImage: pickedImage),
                ),
              );
            }
            } else {
              print('No image selected.');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0.r),
          colorBehindNavBar: Colors.white,
        ),
        isVisible: true,
        navBarHeight: kBottomNavigationBarHeight + 4.h,
        navBarStyle: NavBarStyle.style6,
        padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 400),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
      ),
    );
  }
}

