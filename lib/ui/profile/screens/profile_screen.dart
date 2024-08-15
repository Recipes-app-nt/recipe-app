import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/data/models/user_model.dart';
import 'package:recipe_app/ui/profile/screens/edit_profile_screen.dart';
import 'package:recipe_app/ui/views/recipe/screens/edit_recipe_screen.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? newUser;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _controller = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    // context.read<RecipeBloc>().add(GetUserRecipes());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                      builder: (context) => EditProfileScreen(
                        imageUrl: newUser?.profilePicture,
                        username: newUser?.username,
                        bio: newUser?.bio,
                      ),
                    ),
                  );
                },
                value: "Edit Profile",
                child: const Text('Edit Profile'),
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
            newUser = user;
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
                      backgroundImage: user.profilePicture.isEmpty
                          ? const NetworkImage(
                              "https://img.freepik.com/premium-vector/male-chef-logo-illustration_119589-139.jpg?w=2000")
                          : NetworkImage(user.profilePicture),
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
                if (user.bio.isNotEmpty)
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
                if (user.bio.isEmpty) const Text("No Recorded Bio"),
                const SizedBox(
                  height: 40,
                ),
                TabBar(
                  dividerHeight: 0,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  indicator: BoxDecoration(
                    color: const Color(0xff129575),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  indicatorPadding: const EdgeInsets.all(3.0),
                  indicatorSize: TabBarIndicatorSize.tab,
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      child: Text("Retseptlar"),
                    ),
                    Tab(
                      child: Text("Videolar"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    BlocBuilder<RecipeBloc, RecipeState>(
                      bloc: context.read<RecipeBloc>()..add(GetUserRecipes()),
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

                        if (state is UserRecipeLoaded) {
                          final recipes = state.recipes;
                          return ListView.separated(
                            itemCount: recipes.length,
                            separatorBuilder: (context, index) =>
                                const Gap(20.0),
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return Container(
                                clipBehavior: Clip.hardEdge,
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      recipe!.imageUrl,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton.filled(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditRecipeScreen(
                                                    recipe: recipe,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                          IconButton.filled(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          "Siz ${recipe.title} nomli receptni o'chirishga aminmisiz?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Yo'q"),
                                                        ),
                                                        FilledButton(
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    RecipeBloc>()
                                                                .add(
                                                                  DeleteRecipe(
                                                                    recipe.id,
                                                                  ),
                                                                );
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Ha"),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            recipe.title,
                                            style: const TextStyle(
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
                                              Text(
                                                "${recipe.cookingTime} min",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                              ),
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
