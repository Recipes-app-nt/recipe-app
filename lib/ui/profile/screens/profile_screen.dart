import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_state.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/models/user_model.dart';
import 'package:recipe_app/ui/profile/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (item) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                value: "Edit Profile",
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserStates>(
        bloc: context.read<UserBloc>()..add(GetUserEvent()),
        builder: (context, state) {
          if (state is LoadingUserState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorUserState) {
            return Center(
              child: Text(state.message),
            );
          }

          User? user;

          if (state is LoadedUserState) {
            user = state.user;
          }

          if (user == null) {
            return const Center(
              child: Text("User not found"),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.profilePicture),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Column(
                      children: [
                        Text(
                          "Recipe",
                          style: TextStyle(
                            color: Color(0xFFA9A9A9),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "4",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "Chef",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA9A9A9),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ReadMoreText(
                  user.bio,
                  style: const TextStyle(
                    color: Color(0xFF797979),
                  ),
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  lessStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                TabBar(
                  controller: tabController,
                  indicator: const BoxDecoration(
                      color: Color(0xFF129575),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: -50),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Text(
                        "Recipe",
                        style: TextStyle(
                          color: tabController.index == 0
                              ? Colors.white
                              : const Color(0xFF71B1A1),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Videos",
                        style: TextStyle(
                          color: tabController.index == 1
                              ? Colors.white
                              : const Color(0xFF71B1A1),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        if (state is RecipeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is RecipeError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }

                        if (state is RecipeLoaded) {
                          final recipes = state.recipes;

                          return ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              // final recipe = Recipe.fromJson(recipes[index], id)
                              return Container(
                                clipBehavior: Clip.hardEdge,
                                margin: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://i.pinimg.com/originals/82/68/69/826869734a6637abf7efe5fc8aa8e11d.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  clipBehavior: Clip.hardEdge,
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0),
                                        Colors.black,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Traditional spare ribs backend",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/timer.svg",
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                "20 min",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const Card(
                      child: Text("Card 2"),
                    )
                  ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
