import 'package:flox/core/openai/openai_hackathon_key.dart';

import 'openai_env_io.dart' if (dart.library.html) 'openai_env_stub.dart' as platform;

/// Local / hackathon (priority):
/// 1. [kOpenAiHackathonInlineKey] in `openai_hackathon_key.dart` (bo'sh bo'lmasa)
/// 2. `--dart-define=OPENAI_API_KEY=...`
/// 3. Shell `OPENAI_API_KEY` (VM/desktop)
/// 4. `pubspec.yaml` yonidagi `.env` (VM/desktop)
///
/// Web: [kOpenAiHackathonInlineKey] yoki `--dart-define=OPENAI_API_KEY=...` (boshqa usullar webda ishlamaydi).
abstract final class OpenAiEnv {
  static String get apiKey {
    if (kOpenAiHackathonInlineKey.isNotEmpty) return kOpenAiHackathonInlineKey;
    const fromDefine = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine;
    return platform.readPlatformOpenAiKey();
  }

  static bool get hasApiKey => apiKey.isNotEmpty;
}
