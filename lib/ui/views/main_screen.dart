import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/ui/views/add_screen.dart';
import 'package:recipe_app/ui/views/home_screen.dart';
import 'package:recipe_app/ui/views/notifications_screen.dart';
import 'package:recipe_app/ui/views/profile_screen.dart';
import 'package:recipe_app/ui/views/saved_recipes_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const SavedRecipesScreen(),
    const AddScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF129575),
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeScreen();
                        currentTab = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(currentTab == 0
                          ? "assets/icons/home-active.svg"
                          : "assets/icons/home.svg"),
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const SavedRecipesScreen();
                        currentTab = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(currentTab == 1
                          ? "assets/icons/bookmark_active.svg"
                          : "assets/icons/bookmark.svg"),
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const NotificationsScreen();
                        currentTab = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(currentTab == 2
                          ? "assets/icons/notification-active.svg"
                          : "assets/icons/notification.svg"),
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const ProfileScreen();
                        currentTab = 3;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(currentTab == 3
                          ? "assets/icons/profile_active.svg"
                          : "assets/icons/profile.svg"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
