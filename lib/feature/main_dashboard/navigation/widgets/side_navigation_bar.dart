import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/enums/ui_enums/main_navigation_enum.dart';
import 'package:flox/feature/main_dashboard/navigation/widgets/navigation_account_item.dart';
import 'package:flox/feature/main_dashboard/navigation/widgets/navigation_list_item.dart';
import 'package:flutter/material.dart';

class SideNavigationBar extends StatefulWidget {
  final TabsRouter tabsRouter;

  const SideNavigationBar({
    super.key,
    required this.tabsRouter,
  });

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  final double sideBarWidth = 250;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: sideBarWidth,
      decoration: BoxDecoration(
        color: AppColors.layoutBackground,
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            child: Text('Flox'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final navItem = MainNavigationEnum.values[index];
                final bool isActive = index == widget.tabsRouter.activeIndex;
                return NavigationListItem(
                  navItem: navItem,
                  isActive: isActive,
                  onTap: () {
                    widget.tabsRouter.setActiveIndex(index);
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 4,
            ),
          ),
          NavigationAccountItem(sideBarWidth: sideBarWidth),
        ],
      ),
    );
  }
}
