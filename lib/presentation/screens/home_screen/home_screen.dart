import 'package:flutter/material.dart';

import '../../../widget/home_app_bar_widget.dart';
import '../../../widget/home_story_widget.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    const HomeAppBarWidget();
    const HomeStoryWidget();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HomeAppBarWidget(),
          HomeStoryWidget(),
        ],
      )
    );
  }
}
