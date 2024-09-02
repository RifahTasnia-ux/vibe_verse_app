import 'package:flutter/material.dart';
import 'package:vibe_verse/widget/profile_grid_view_widget.dart';

class ProfileGridListWidget extends StatelessWidget {
  const ProfileGridListWidget({
    super.key, required List<Map<String, dynamic>> posts,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [
              TabBar(
                indicatorColor: Color(0xff101828),
                indicatorWeight: 0.1,
                labelColor: Color(0xff101828),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_view),
                        SizedBox(width: 8),
                        Text("Grid view",style: TextStyle(
                          fontSize: 15,
                        ),),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list),
                        SizedBox(width: 8),
                        Text("List view",style: TextStyle(
                          fontSize: 15,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StaggeredGridWidget(),
                    Center(child: Text("List view content")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}