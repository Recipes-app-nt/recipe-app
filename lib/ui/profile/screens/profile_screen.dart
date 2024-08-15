/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/blocs/video_player/video_bloc.dart';
import 'package:recipe_app/blocs/video_player/video_event.dart';
import 'package:recipe_app/blocs/video_player/video_state.dart';
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
  int myRetseptsCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc()..add(LoadVideos(videoUrls)),
      child: Scaffold(
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
                      Column(
                        children: [
                          Text(
                            "Recipe",
                            style: TextStyle(
                              color: Color(0xFFA9A9A9),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myRetseptsCount.toString(),
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
                                              color: Colors.white,),),
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
      
                            for (int i = 0; i < recipes.length; i++) {
                              if(recipes[i]!.videoUrl != '' && !videoUrls.contains(recipes[i]!.videoUrl)) {
                                videoUrls.add(recipes[i]!.videoUrl);
                              }
                            }
      
                            myRetseptsCount = recipes.length;
                            return recipes.isEmpty
                                ? const Center(
                                    child: Text(
                                        "Siz hech qanday retsept yaratmadingiz"),
                                  )
                                : ListView.separated(
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
                                              recipe!.imageUrl != '' ? recipe.imageUrl : "https://i.pinimg.com/originals/33/59/c7/3359c7e5febfed141c99f1a04ad38821.jpg" ,

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
                                                    onPressed: () async {
                                                      final data =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditRecipeScreen(
                                                                  recipe: recipe),
                                                        ),
                                                      );
      
                                                      if (data == true) {
                                                        context
                                                            .read<RecipeBloc>()
                                                            .add(
                                                                GetUserRecipes());
                                                      }
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
                                                                  child:
                                                                      const Text(
                                                                          "Yo'q"),
                                                                ),
                                                                FilledButton(
                                                                  onPressed: () {
                                                                    context
                                                                        .read<
                                                                            RecipeBloc>()
                                                                        .add(DeleteRecipe(
                                                                            recipe
                                                                                .id));
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Text("Ha"),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon:
                                                        const Icon(Icons.delete),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                          color:
                                                              Color(0xFFD9D9D9),
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
                      BlocBuilder<VideoBloc, VideoState>(
                        builder: (context, state) {
                          if (state.controllers.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Gap(20.0),
                            itemCount: state.controllers.length,
                            itemBuilder: (context, index) {
                              final controller = state.controllers[index];
                              bool isPlaying = state.playingIndex ==
                                  index; // Check if this video is playing
                              return Column(
                                children: [
                                  if (controller.value.isInitialized)
                                    Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio:
                                              controller.value.aspectRatio,
                                          child: VideoPlayer(controller),
                                        ),
                                        Positioned.fill(
                                          child: Center(
                                            child: IconButton.filled(
                                              onPressed: () {
                                                if (isPlaying) {
                                                  context
                                                      .read<VideoBloc>()
                                                      .add(PauseVideo(index));
                                                } else {
                                                  context
                                                      .read<VideoBloc>()
                                                      .add(PlayVideo(index));
                                                }
                                              },
                                              icon: Icon(isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ]),
                  )
                ],
              ),
                            );
          },
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/blocs/video_player/video_bloc.dart';
import 'package:recipe_app/blocs/video_player/video_event.dart';
import 'package:recipe_app/blocs/video_player/video_state.dart';
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
  int myRetseptsCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc()..add(LoadVideos(videoUrls)),
      child: Scaffold(
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
                      Column(
                        children: [
                          Text(
                            "Recipe",
                            style: TextStyle(
                              color: Color(0xFFA9A9A9),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            myRetseptsCount.toString(),
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

                            for (int i = 0; i < recipes.length; i++) {
                              if (recipes[i]!.videoUrl != '' &&
                                  !videoUrls.contains(recipes[i]!.videoUrl)) {
                                videoUrls.add(recipes[i]!.videoUrl);
                              }
                            }

                            myRetseptsCount = recipes.length;
                            return recipes.isEmpty
                                ? const Center(
                                    child: Text(
                                        "Siz hech qanday retsept yaratmadingiz"),
                                  )
                                : ListView.separated(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              recipe!.imageUrl != ''
                                                  ? recipe.imageUrl
                                                  : "https://i.pinimg.com/originals/33/59/c7/3359c7e5febfed141c99f1a04ad38821.jpg",
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
                                                    onPressed: () async {
                                                      final data =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditRecipeScreen(
                                                                  recipe:
                                                                      recipe),
                                                        ),
                                                      );

                                                      if (data == true) {
                                                        context
                                                            .read<RecipeBloc>()
                                                            .add(
                                                                GetUserRecipes());
                                                      }
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Yo'q"),
                                                                ),
                                                                FilledButton(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            RecipeBloc>()
                                                                        .add(DeleteRecipe(
                                                                            recipe.id));
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Ha"),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    recipe.title,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                          color:
                                                              Color(0xFFD9D9D9),
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
                      BlocBuilder<VideoBloc, VideoState>(
                        builder: (context, state) {
                          if (state.controllers.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Gap(20.0),
                            itemCount: state.controllers.length,
                            itemBuilder: (context, index) {
                              final controller = state.controllers[index];
                              bool isPlaying = state.playingIndex ==
                                  index; // Check if this video is playing
                              return Column(
                                children: [
                                  if (controller.value.isInitialized)
                                    Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio:
                                              controller.value.aspectRatio,
                                          child: VideoPlayer(controller),
                                        ),
                                        Positioned.fill(
                                          child: Center(
                                            child: IconButton.filled(
                                              onPressed: () {
                                                if (isPlaying) {
                                                  context
                                                      .read<VideoBloc>()
                                                      .add(PauseVideo(index));
                                                } else {
                                                  context
                                                      .read<VideoBloc>()
                                                      .add(PlayVideo(index));
                                                }
                                              },
                                              icon: Icon(isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ]),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
