import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabSelector extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String thirtText;
  final TabController tabController;

  const TabSelector({
    super.key,
    required this.tabController,
    required this.firstText,
    required this.secondText,
    required this.thirtText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TabBar(
        dividerHeight: 0,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          color: const Color(0xff129575),
          borderRadius: BorderRadius.circular(12.0),
        ),
        indicatorPadding: const EdgeInsets.all(5.0),
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        tabs: [
          Tab(
            text: firstText,
          ),
          Tab(
            text: secondText,
          ),
          Tab(
            text: thirtText,
          ),
        ],
      ),
    );
  }
}
