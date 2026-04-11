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
      width: 278,
      decoration: BoxDecoration(
        color: AppColors.layoutBackground,
        border: Border(
          right: BorderSide(color: AppColors.dividerColor.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.6)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                dividerColor: AppColors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.subtitle,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                tabs: const [
                  Tab(text: 'Elementlar'),
                  Tab(text: 'Sahifa'),
                ],
              ),
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
