import 'dart:convert';

import 'package:flox/feature/hackathon_ai/models/ai_funnel_draft.dart';

final RegExp _jsonFence = RegExp(r'```(?:json)?\s*([\s\S]*?)```', multiLine: true);

String? extractJsonFence(String text) {
  final m = _jsonFence.firstMatch(text);
  return m?.group(1)?.trim();
}

/// Butun xabarni yoki birinchi ```json``` blokini parse qiladi.
AiFunnelDraft? tryParseFloxDraft(String assistantText) {
  String? raw = extractJsonFence(assistantText);
  raw ??= assistantText.trim();
  if (raw.isEmpty) return null;
  if (!raw.startsWith('{')) {
    raw = extractJsonFence(assistantText);
    if (raw == null || raw.isEmpty) return null;
  }
  try {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final draft = AiFunnelDraft.fromJson(map);
    if (draft.pages.isEmpty) return null;
    return draft;
  } catch (_) {
    return null;
  }
}

/// Har sahifada kamida 2 ta yaroqli 6 xonali gradient rang.
/// Bir nechta sahifada `content` bo‘lsa, barchasida bo‘lishi kerak (aralash eski/yangi tuzilma rad).
bool isDraftContentPagesConsistent(AiFunnelDraft draft) {
  if (draft.pages.isEmpty) return true;
  final any = draft.pages.any((p) => p.content.isNotEmpty);
  if (!any) return true;
  return draft.pages.every((p) => p.content.isNotEmpty);
}

bool isValidDraftPageGradients(AiFunnelDraft draft) {
  for (final pg in draft.pages) {
    var n = 0;
    for (final raw in pg.gradientColors) {
      var s = raw.replaceAll('#', '').trim();
      if (s.length == 8) s = s.substring(2);
      if (s.length == 6 && RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(s)) n++;
    }
    if (n < 2) return false;
  }
  return true;
}
