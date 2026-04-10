import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/main_dashboard/navigation/core_cubit/core_cubit.dart';
import 'package:flox/feature/main_dashboard/navigation/widgets/side_navigation_bar.dart';
import 'package:flox/feature/main_dashboard/settings/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late final CoreCubit _coreCubit;
  late final SettingsCubit _settingsCubit;
  @override
  void initState() {
    _coreCubit = getIt<CoreCubit>();
    _settingsCubit = getIt<SettingsCubit>();
    _settingsCubit.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _coreCubit),
        BlocProvider.value(value: _settingsCubit),
      ],
      child: AutoTabsRouter(
        lazyLoad: true,
        routes: [
          MyFunnelsRoute(),
          AnalyticsRoute(),
          BillingRoute(),
          SettingsRoute(),
        ],
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            body: Row(
              children: [
                SideNavigationBar(tabsRouter: tabsRouter),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}
