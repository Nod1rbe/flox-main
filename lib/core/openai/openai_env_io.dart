import 'dart:io' show Directory, File, Platform;

String readPlatformOpenAiKey() {
  final fromEnv = Platform.environment['OPENAI_API_KEY'];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  return _readOpenAiKeyFromDotEnv();
}

/// When the app is started from an IDE, [Directory.current] is not always the repo root.
/// Walk up until `pubspec.yaml` is found and read `.env` from that folder first.
Directory? _directoryWithPubspec() {
  var dir = Directory.current;
  for (var i = 0; i < 32; i++) {
    if (File.fromUri(dir.uri.resolve('pubspec.yaml')).existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
  return null;
}

String _readOpenAiKeyFromDotEnv() {
  final candidates = <File>[];
  final root = _directoryWithPubspec();
  if (root != null) {
    candidates.add(File.fromUri(root.uri.resolve('.env')));
  }
  candidates.add(File('.env'));

  final seen = <String>{};
  for (final file in candidates) {
    try {
      final path = file.absolute.path;
      if (seen.contains(path)) continue;
      seen.add(path);
      final value = _parseOpenAiKeyFromFile(file);
      if (value.isNotEmpty) return value;
    } catch (_) {}
  }
  return '';
}

String _parseOpenAiKeyFromFile(File file) {
  if (!file.existsSync()) return '';
  for (final raw in file.readAsLinesSync()) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq <= 0) continue;
    final key = line.substring(0, eq).trim();
    if (key != 'OPENAI_API_KEY') continue;
    var value = line.substring(eq + 1).trim();
    if (value.length >= 2) {
      final q = value[0];
      if ((q == '"' || q == "'") && value.endsWith(q)) {
        value = value.substring(1, value.length - 1);
      }
    }
    return value;
  }
  return '';
}
