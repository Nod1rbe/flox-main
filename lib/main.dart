import 'package:firebase_core/firebase_core.dart';
import 'package:flox/core/constants/app_configs.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/routes/app_router.dart';
import 'package:flox/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: AppConfigs.supabaseUrl, anonKey: AppConfigs.supabaseAnonKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const FloxApp());
}

class FloxApp extends StatefulWidget {
  const FloxApp({super.key});

  @override
  State<FloxApp> createState() => _FloxAppState();
}

class _FloxAppState extends State<FloxApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flox',
      debugShowCheckedModeBanner: false,
      routerConfig: getIt<AppRouter>().config(),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
