import 'package:flox/core/di/injection.config.dart';
import 'package:flox/core/routes/app_router.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
  getIt.registerSingleton<AppRouter>(AppRouter());
}
