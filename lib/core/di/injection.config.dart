// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flox/feature/authentication/bloc/authentication_bloc.dart'
    as _i9;
import 'package:flox/feature/authentication/data/auth_repository.dart' as _i48;
import 'package:flox/feature/builder/blocs/builder_manager_bloc/builder_manager_cubit.dart'
    as _i258;
import 'package:flox/feature/builder/repositories/builder_repository.dart'
    as _i461;
import 'package:flox/feature/main_dashboard/analytics/cubit/analytics_cubit/analytics_cubit.dart'
    as _i595;
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart'
    as _i495;
import 'package:flox/feature/main_dashboard/analytics/data/repository/analytics_repository.dart'
    as _i271;
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart'
    as _i723;
import 'package:flox/feature/main_dashboard/my_funnels/data/repository/funnels_projects_repository.dart'
    as _i974;
import 'package:flox/feature/main_dashboard/navigation/core_cubit/core_cubit.dart'
    as _i410;
import 'package:flox/feature/main_dashboard/settings/data/repository/settings_repository.dart'
    as _i639;
import 'package:flox/feature/main_dashboard/settings/settings_cubit/settings_cubit.dart'
    as _i631;
import 'package:flox/feature/splash/splash_bloc/splash_bloc.dart' as _i456;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i48.AuthRepository>(() => _i48.AuthRepository());
    gh.factory<_i461.BuilderRepository>(() => _i461.BuilderRepository());
    gh.factory<_i271.AnalyticsRepository>(() => _i271.AnalyticsRepository());
    gh.factory<_i974.FunnelsProjectsRepository>(
        () => _i974.FunnelsProjectsRepository());
    gh.factory<_i639.SettingsRepository>(() => _i639.SettingsRepository());
    gh.lazySingleton<_i410.CoreCubit>(() => _i410.CoreCubit());
    gh.factory<_i595.AnalyticsCubit>(
        () => _i595.AnalyticsCubit(gh<_i271.AnalyticsRepository>()));
    gh.factory<_i495.PageViewsCubit>(() => _i495.PageViewsCubit(
          gh<_i974.FunnelsProjectsRepository>(),
          gh<_i271.AnalyticsRepository>(),
        ));
    gh.factory<_i258.BuilderManagerCubit>(
        () => _i258.BuilderManagerCubit(gh<_i461.BuilderRepository>()));
    gh.factory<_i9.AuthenticationBloc>(
        () => _i9.AuthenticationBloc(gh<_i48.AuthRepository>()));
    gh.factory<_i456.SplashBloc>(
        () => _i456.SplashBloc(gh<_i48.AuthRepository>()));
    gh.factory<_i631.SettingsCubit>(
        () => _i631.SettingsCubit(gh<_i639.SettingsRepository>()));
    gh.factory<_i723.FunnelProjectsBloc>(
        () => _i723.FunnelProjectsBloc(gh<_i974.FunnelsProjectsRepository>()));
    return this;
  }
}
