import 'package:flox/core/gen/assets.gen.dart';

enum MainNavigationEnum {
  myFunnels('Funnels'),
  analytics('Analytics'),
  billing('Billing'),
  settings('Settings'),
  account('Account');

  final String name;

  const MainNavigationEnum(this.name);

  SvgGenImage get icon {
    switch (this) {
      case MainNavigationEnum.myFunnels:
        return Assets.icons.funnelIcon;
      case MainNavigationEnum.analytics:
        return Assets.icons.analytics;
      case MainNavigationEnum.billing:
        return Assets.icons.billing;
      case MainNavigationEnum.account:
        return Assets.icons.user;
      case MainNavigationEnum.settings:
        return Assets.icons.settings;
    }
  }
}
