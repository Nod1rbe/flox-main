// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flox/feature/authentication/ui/authentication_page.dart' as _i2;
import 'package:flox/feature/builder/ui/builder_page.dart' as _i4;
import 'package:flox/feature/main_dashboard/analytics/ui/analytics_page.dart'
    as _i1;
import 'package:flox/feature/main_dashboard/billing/billing_page.dart' as _i3;
import 'package:flox/feature/main_dashboard/my_funnels/ui/my_funnels_page.dart'
    as _i10;
import 'package:flox/feature/main_dashboard/navigation/main_navigation_page.dart'
    as _i8;
import 'package:flox/feature/main_dashboard/settings/ui/settings_page.dart'
    as _i11;
import 'package:flox/feature/splash/ui/splash_page.dart' as _i12;
import 'package:flox/feature/test_pages/experience_h.dart' as _i5;
import 'package:flox/feature/test_pages/experience_n.dart' as _i6;
import 'package:flox/feature/test_pages/experience_s.dart' as _i7;
import 'package:flox/ui_components/mobile_block_page.dart' as _i9;
import 'package:flutter/material.dart' as _i14;

/// generated route for
/// [_i1.AnalyticsPage]
class AnalyticsRoute extends _i13.PageRouteInfo<void> {
  const AnalyticsRoute({List<_i13.PageRouteInfo>? children})
    : super(AnalyticsRoute.name, initialChildren: children);

  static const String name = 'AnalyticsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i1.AnalyticsPage();
    },
  );
}

/// generated route for
/// [_i2.AuthenticationPage]
class AuthenticationRoute extends _i13.PageRouteInfo<void> {
  const AuthenticationRoute({List<_i13.PageRouteInfo>? children})
    : super(AuthenticationRoute.name, initialChildren: children);

  static const String name = 'AuthenticationRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthenticationPage();
    },
  );
}

/// generated route for
/// [_i3.BillingPage]
class BillingRoute extends _i13.PageRouteInfo<void> {
  const BillingRoute({List<_i13.PageRouteInfo>? children})
    : super(BillingRoute.name, initialChildren: children);

  static const String name = 'BillingRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.BillingPage();
    },
  );
}

/// generated route for
/// [_i4.BuilderPage]
class BuilderRoute extends _i13.PageRouteInfo<BuilderRouteArgs> {
  BuilderRoute({
    _i14.Key? key,
    required String? funnelId,
    required bool? isEditing,
    required String? funnelName,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         BuilderRoute.name,
         args: BuilderRouteArgs(
           key: key,
           funnelId: funnelId,
           isEditing: isEditing,
           funnelName: funnelName,
         ),
         rawQueryParams: {
           'fid': funnelId,
           'editing': isEditing,
           'name': funnelName,
         },
         initialChildren: children,
       );

  static const String name = 'BuilderRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<BuilderRouteArgs>(
        orElse:
            () => BuilderRouteArgs(
              funnelId: queryParams.optString('fid'),
              isEditing: queryParams.optBool('editing'),
              funnelName: queryParams.optString('name'),
            ),
      );
      return _i4.BuilderPage(
        key: args.key,
        funnelId: args.funnelId,
        isEditing: args.isEditing,
        funnelName: args.funnelName,
      );
    },
  );
}

class BuilderRouteArgs {
  const BuilderRouteArgs({
    this.key,
    required this.funnelId,
    required this.isEditing,
    required this.funnelName,
  });

  final _i14.Key? key;

  final String? funnelId;

  final bool? isEditing;

  final String? funnelName;

  @override
  String toString() {
    return 'BuilderRouteArgs{key: $key, funnelId: $funnelId, isEditing: $isEditing, funnelName: $funnelName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BuilderRouteArgs) return false;
    return key == other.key &&
        funnelId == other.funnelId &&
        isEditing == other.isEditing &&
        funnelName == other.funnelName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      funnelId.hashCode ^
      isEditing.hashCode ^
      funnelName.hashCode;
}

/// generated route for
/// [_i5.ExperienceHPage]
class ExperienceHRoute extends _i13.PageRouteInfo<void> {
  const ExperienceHRoute({List<_i13.PageRouteInfo>? children})
    : super(ExperienceHRoute.name, initialChildren: children);

  static const String name = 'ExperienceHRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i5.ExperienceHPage();
    },
  );
}

/// generated route for
/// [_i6.ExperienceNPage]
class ExperienceNRoute extends _i13.PageRouteInfo<void> {
  const ExperienceNRoute({List<_i13.PageRouteInfo>? children})
    : super(ExperienceNRoute.name, initialChildren: children);

  static const String name = 'ExperienceNRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.ExperienceNPage();
    },
  );
}

/// generated route for
/// [_i7.ExperienceSPage]
class ExperienceSRoute extends _i13.PageRouteInfo<void> {
  const ExperienceSRoute({List<_i13.PageRouteInfo>? children})
    : super(ExperienceSRoute.name, initialChildren: children);

  static const String name = 'ExperienceSRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i7.ExperienceSPage();
    },
  );
}

/// generated route for
/// [_i8.MainNavigationPage]
class MainNavigationRoute extends _i13.PageRouteInfo<void> {
  const MainNavigationRoute({List<_i13.PageRouteInfo>? children})
    : super(MainNavigationRoute.name, initialChildren: children);

  static const String name = 'MainNavigationRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i8.MainNavigationPage();
    },
  );
}

/// generated route for
/// [_i9.MobileBlockPage]
class MobileBlockRoute extends _i13.PageRouteInfo<void> {
  const MobileBlockRoute({List<_i13.PageRouteInfo>? children})
    : super(MobileBlockRoute.name, initialChildren: children);

  static const String name = 'MobileBlockRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i9.MobileBlockPage();
    },
  );
}

/// generated route for
/// [_i10.MyFunnelsPage]
class MyFunnelsRoute extends _i13.PageRouteInfo<void> {
  const MyFunnelsRoute({List<_i13.PageRouteInfo>? children})
    : super(MyFunnelsRoute.name, initialChildren: children);

  static const String name = 'MyFunnelsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i10.MyFunnelsPage();
    },
  );
}

/// generated route for
/// [_i11.SettingsPage]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute({List<_i13.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.SettingsPage();
    },
  );
}

/// generated route for
/// [_i12.SplashPage]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.SplashPage();
    },
  );
}
