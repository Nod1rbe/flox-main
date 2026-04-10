import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/ui/sections/page_settings_section.dart';
import 'package:flox/feature/builder/ui/sections/ui_components_section.dart';
import 'package:flutter/material.dart';

class ElementsLayout extends StatefulWidget {
  const ElementsLayout({super.key});

  @override
  State<ElementsLayout> createState() => _ElementsLayoutState();
}

class _ElementsLayoutState extends State<ElementsLayout> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 270,
      color: AppColors.layoutBackground,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 20,
            ),
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.defaultButtonBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary,
              ),
              dividerColor: AppColors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              tabs: const [
                Tab(text: "Elements"),
                Tab(text: "Page Settings"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                UIComponentsSection(),
                PageSettingsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
