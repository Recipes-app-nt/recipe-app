/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../blocs/navigation/navigation_bloc.dart';
import '../profile/screens/profile_screen.dart';
import 'home/screens/home_screen.dart';
import 'notifications_screen.dart';
import 'recipe/screens/add_recipe_screen.dart';
import 'saved_recipes_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: _getIndexForState(state),
            children: const [
              HomeScreen(),
              SavedRecipesScreen(),
              NotificationsScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF129575),
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddRecipeScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  int _getIndexForState(NavigationState state) {
    if (state is HomePage) return 0;
    if (state is FavoritePage) return 1;
    if (state is NotificationPage) return 2;
    if (state is ProfilePage) return 3;
    return 0;
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, NavigationState state) {
    return BottomAppBar(
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
                _buildNavItem(context, 0, "home", state is HomePage),
                _buildNavItem(context, 1, "bookmark", state is FavoritePage),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildNavItem(
                    context, 2, "notification", state is NotificationPage),
                _buildNavItem(context, 3, "profile", state is ProfilePage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, String iconName, bool isActive) {
    return MaterialButton(
      shape: const CircleBorder(),
      minWidth: 40,
      onPressed: () =>
          context.read<NavigationBloc>().add(PageTapped(index: index)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          isActive
              ? "assets/icons/${iconName}_active.svg"
              : "assets/icons/$iconName.svg",
        ),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/ui/views/home/screens/home_screen.dart';
import 'package:recipe_app/ui/profile/screens/profile_screen.dart';
import 'package:recipe_app/ui/views/notifications_screen.dart';
import 'package:recipe_app/ui/views/recipe/screens/add_recipe_screen.dart';
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
    const AddRecipeScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
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
        onPressed: () {
          // currentScreen = screens[2];
          // setState(() {});
          // currentTab = 4;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRecipeScreen(),
            ),
          );
        },
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
                          ? "assets/icons/home_active.svg"
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
                      child: SvgPicture.asset(
                        currentTab == 2
                            ? "assets/icons/notification_active.svg"
                            : "assets/icons/notification.svg",
                      ),
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
