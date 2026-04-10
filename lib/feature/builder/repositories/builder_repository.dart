import 'package:dartz/dartz.dart';
import 'package:flox/core/constants/app_configs.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flox/feature/builder/ui/model/page_model/page_model.dart';
import 'package:flox/templates/template1.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class BuilderRepository {
  SupabaseClient get supabase => Supabase.instance.client;

  PostgrestQueryBuilder get _funnels => supabase.from('funnels');
  PostgrestQueryBuilder get _pages => supabase.from('pages');

  Future<Either<String, List<PageData>>> getFunnel({required String funnelId}) async {
    try {
      final response = await _pages.select().eq('funnel_id', funnelId).order('page_order', ascending: true);
      final List<PageModel> pages = response.map((e) => PageModel.fromJson(e)).toList();
      if (pages.isEmpty) return left('No pages found');
      final List<PageData> pageEntities = pages.map((e) {
        return PageData(
          configs: e.configs?.map((config) => BaseConfig.fromModel(config)).toList() ?? [],
          pageSettingsConfig: PageSettingsConfig.fromModel(e.pageSettingsConfig!),
          navButton: ButtonConfig.fromModel((e.navButton ?? template1[0].navButton) as ButtonModel),
          pageId: e.pageId ?? 0,
          pageOrder: e.pageOrder ?? 0,
        );
      }).toList();

      return right(pageEntities);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, List<String>>> uploadFunnel({required List<PageData> pages, required String funnelId}) async {
    try {
      List<String> launcherLinks = [];
      await _pages.delete().eq('funnel_id', funnelId);
      await Future.wait(
        pages.map((page) {
          final data = {
            'page_order': page.pageOrder,
            'configs': page.configs.map((c) => c.toModel().toJson()).toList(),
            'funnel_id': funnelId,
            'page_settings': page.pageSettingsConfig.toModel().toJson(),
            'nav_button': page.navButton.toModel().toJson(),
          };
          return _pages.insert(data);
        }),
      );

      for (int i = 0; i < AppConfigs.launcherSources.length; i++) {
        launcherLinks.add('${AppConfigs.launcherHostUrl}?source=${AppConfigs.launcherSources[i]}&fid=$funnelId');
      }
      await _funnels.update({'links': launcherLinks}).eq('id', funnelId);
      return right(launcherLinks);
    } catch (e) {
      return left(e.toString());
    }
  }
}
