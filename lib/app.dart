import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibe_verse/presentation/screens/auth/splash_screen.dart';

class VibeVerseApp extends StatelessWidget {
  const VibeVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return  const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Vibe Verse",
          // theme: AppTheme.lightTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
