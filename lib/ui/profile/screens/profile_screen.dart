import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/data/models/user_model.dart';

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          )
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
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          "https://www.escoffier.edu/wp-content/uploads/2022/03/Female-chef-plating-and-garnishing-a-breaded-chicken-dish-768.jpg"),
                    ),
                    SizedBox(
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
                const Text(
                  "Afuwape Abiodun",
                  style: TextStyle(
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
                const ReadMoreText(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Why do we use it?. There are many variations of ",
                  style: TextStyle(
                    color: Color(0xFF797979),
                  ),
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  lessStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                Expanded(
                  child: TabBarView(controller: tabController, children: const [
                    Card(
                      child: Text("Card 1"),
                    ),
                    Card(
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
