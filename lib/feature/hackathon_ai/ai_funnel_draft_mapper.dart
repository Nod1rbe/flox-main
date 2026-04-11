import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flox/feature/builder/configs/page_settings_config/model/gradient_settings_model.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_default_style_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_option_values_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_selection_style_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flox/feature/builder/configs/payment_config/model/payment_model.dart';
import 'package:flox/feature/builder/configs/payment_config/payment_config.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_values_model.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flox/feature/hackathon_ai/models/ai_funnel_draft.dart';
import 'package:flutter/material.dart';

bool _isTrustedThematicImageUrl(String u) {
  final uri = Uri.tryParse(u);
  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) return false;
  final host = uri.host.toLowerCase();
  if (host == 'via.placeholder.com' || host.contains('placehold.co')) return false;
  if (host == 'example.com' || host.endsWith('.example.com')) return false;
  if (host.contains('dummyimage.com')) return false;
  // picsum — mavzuga bog‘liq emas, teglarga tushamiz
  if (host.contains('picsum.photos')) return false;
  if (host.contains('unsplash.com')) return true;
  if (host.contains('pexels.com')) return true;
  if (host.contains('pixabay.com')) return true;
  if (host.contains('wikimedia.org') || host.contains('upload.wikimedia.org')) return true;
  if (host.contains('loremflickr.com')) return true;
  return host.isNotEmpty;
}

List<String> _splitHint(String? hint) {
  if (hint == null || hint.trim().isEmpty) return [];
  return hint
      .split(RegExp(r'[,;\s/]+'))
      .map((s) => s.trim())
      .where((s) => s.length >= 2)
      .toList();
}

List<String> _sanitizeStockTags(Iterable<String> raw, {int maxEach = 22}) {
  final out = <String>[];
  final seen = <String>{};
  for (final t in raw) {
    var s = t.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '').toLowerCase();
    if (s.length > maxEach) s = s.substring(0, maxEach);
    if (s.length < 2) continue;
    if (seen.add(s)) out.add(s);
  }
  return out;
}

List<String> _latinTokensFromName(String name) {
  return RegExp(r'[a-zA-Z]{3,}')
      .allMatches(name)
      .map((m) => m.group(0)!.toLowerCase())
      .toList();
}

String _analyticsFieldName(String? preferred, String fallback) {
  final base = (preferred != null && preferred.trim().isNotEmpty)
      ? preferred.trim()
      : fallback;
  var t = base.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  if (t.isEmpty || t == '_') t = 'field';
  if (t.length > 48) t = t.substring(0, 48);
  return t;
}

/// Sahifa + butun biznes teglari birlashtiriladi; URL bo‘lsa faqat ishonchli CDN qabul qilinadi.
String _resolvePageImageUrl(
  AiFunnelPageDraft p,
  int pageIndex,
  AiFunnelDraft draft, {
  String? imageUrl,
  List<String>? imageTags,
  String? pageImageHint,
}) {
  final u = (imageUrl ?? p.imageUrl)?.trim();
  if (u != null && u.isNotEmpty && _isTrustedThematicImageUrl(u)) {
    return u;
  }

  final hintTags = _splitHint(pageImageHint ?? p.pageImageHint);
  final merged = <String>[
    ...(imageTags ?? p.imageTags),
    ...hintTags,
    ...draft.businessImageTags,
  ];
  var tags = _sanitizeStockTags(merged);
  if (tags.isEmpty) {
    tags = _sanitizeStockTags(_latinTokensFromName(draft.funnelName));
  }
  if (tags.isEmpty) {
    tags = ['business', 'workspace'];
  }

  final pathTags = tags.take(4).join(',');
  final w = 520 + (pageIndex % 4);
  final h = 300 + (pageIndex % 7) * 14;
  return 'https://loremflickr.com/$w/$h/$pathTags';
}

String _rgbHex6(Color c) {
  final h = c.toHexString(leadingHashSign: false).toUpperCase();
  if (h.length >= 8) return h.substring(2, 8);
  return h.length == 6 ? h : h.padLeft(6, '0').substring(0, 6);
}

String? _singleHex6(String raw) {
  var s = raw.replaceAll('#', '').trim().toUpperCase();
  if (s.length == 8) s = s.substring(2);
  if (s.length != 6 || !RegExp(r'^[0-9A-F]{6}').hasMatch(s)) return null;
  return s;
}

String _hexForUi(String? raw, String fallbackNoHash) {
  final h = _singleHex6((raw ?? '').replaceAll('#', ''));
  if (h != null) return h;
  return _singleHex6(fallbackNoHash.replaceAll('#', '')) ?? '657DE8';
}

String _httpsPaymentUrl(String? u, String pathIfInvalid) {
  final t = u?.trim();
  if (t != null && t.isNotEmpty) {
    final uri = Uri.tryParse(t);
    if (uri != null && (uri.isScheme('https') || uri.isScheme('http'))) {
      return t;
    }
  }
  return 'https://example.com$pathIfInvalid';
}

/// Sahifa foni faqat gradient: kamida 2 ta rang; bo‘lsa ham juftlikni kafolatlaymiz.
List<String> _normalizeGradientHexes(AiFunnelPageDraft p) {
  final out = <String>[];
  for (final raw in p.gradientColors) {
    final h = _singleHex6(raw);
    if (h != null) {
      out.add(h);
      if (out.length >= 4) break;
    }
  }
  if (out.length >= 2) return out;
  if (out.length == 1) {
    final c = out.single.toColor;
    final hsl = HSLColor.fromColor(c);
    final end = hsl.withLightness((hsl.lightness * 0.52).clamp(0.06, 0.45)).toColor();
    return [out.single, _rgbHex6(end)];
  }
  final anchor = _singleHex6(p.backgroundColor);
  if (anchor != null) {
    final c = anchor.toColor;
    final hsl = HSLColor.fromColor(c);
    final end = hsl.withLightness((hsl.lightness * 0.5).clamp(0.06, 0.45)).toColor();
    return [anchor, _rgbHex6(end)];
  }
  return const ['1A1A2E', '533483'];
}

void _appendTextDraft(List<BaseConfig> configs, AiTextBlockDraft b) {
  final align = switch ((b.alignment ?? 'center').toLowerCase()) {
    'left' => TextAlign.left,
    'right' => TextAlign.right,
    _ => TextAlign.center,
  };
  configs.add(
    TextConfig(
      text: b.text,
      leadingIcon: '',
      color: (b.color ?? 'E4E4E4').toColor,
      size: b.size ?? 16,
      alignment: align,
      weight: TextWeightType.fromModel(b.weight ?? 500),
      fontFamily: FontOptions.defaultFont,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    ),
  );
}

void _appendContentBlock(
  List<BaseConfig> configs,
  AiPageContentBlock b,
  AiFunnelPageDraft p,
  int pageIndex,
  AiFunnelDraft draft,
) {
  switch (b.normalizedKind) {
    case 'text':
      _appendTextDraft(
        configs,
        AiTextBlockDraft(
          text: b.text ?? '',
          size: b.size,
          color: b.color,
          weight: b.weight,
          alignment: b.alignment,
        ),
      );
    case 'image':
      configs.add(
        ImageConfig(
          fit: BoxFit.cover,
          imageUrl: _resolvePageImageUrl(
            p,
            pageIndex,
            draft,
            imageUrl: b.imageUrl,
            imageTags: b.imageTags.isNotEmpty ? b.imageTags : null,
            pageImageHint: b.pageImageHint,
          ),
          alignment: Alignment.center,
          height: 200,
          width: 320,
          cornerRadius: 14,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        ),
      );
    case 'textfield':
      final hint = (b.hintText?.trim().isNotEmpty ?? false) ? b.hintText!.trim() : 'Maʼlumot kiriting';
      configs.add(
        TextFieldConfig.fromModel(
          TextFieldModel(
            padding: PaddingModel(left: 16, right: 16, top: 8, bottom: 8),
            hintText: hint,
            analyticsFieldsName: _analyticsFieldName(b.analyticsFieldName, hint),
            cornerRadius: 10,
            alignment: 'center',
            textColor: 'E4E4E4',
            backgroundColor: '333333',
            fontWeight: 400,
            fontSize: 16,
            fontFamily: FontOptions.defaultFont,
          ),
        ),
      );
    case 'multiplechoice':
      if (b.options.length < 2) return;
      final q = b.question?.trim();
      if (q != null && q.isNotEmpty) {
        _appendTextDraft(
          configs,
          AiTextBlockDraft(
            text: q,
            size: b.size ?? 18,
            color: b.color ?? 'E4E4E4',
            weight: b.weight ?? 600,
            alignment: b.alignment ?? 'center',
          ),
        );
      }
      final fieldKey = q ?? b.options.first;
      configs.add(
        MultipleChoiceConfig.fromModel(
          MultipleChoiceModel(
            padding: PaddingModel(left: 16, right: 16, top: 8, bottom: 8),
            analyticsFieldsName: _analyticsFieldName(b.analyticsFieldName, fieldKey),
            optionValues: b.options
                .map((t) => McOptionValuesModel(text: t, leadingIcon: ''))
                .toList(),
            defaultStyle: McDefaultStyleModel.sample(),
            selectionStyle: McSelectionStyleModel.sample(),
          ),
        ),
      );
    case 'progress':
      final values = b.progressSteps.isNotEmpty
          ? b.progressSteps
              .map((s) => ProgressValuesModel(text: s.label, duration: s.duration))
              .toList()
          : [
              ProgressValuesModel.sample1(),
              ProgressValuesModel.sample2(),
              ProgressValuesModel.sample3(),
            ];
      configs.add(
        ProgressConfig.fromModel(
          ProgressModel(
            padding: PaddingModel(left: 16, right: 16, top: 12, bottom: 8),
            height: 14,
            cornerRadius: 24,
            showIcon: false,
            textColor: 'E4E4E4',
            backgroundColor: '333333',
            fontWeight: 400,
            fontSize: 14,
            fontFamily: FontOptions.defaultFont,
            progressValues: values,
          ),
        ),
      );
    case 'payment':
      final amount = (b.amount ?? 0) > 0 ? b.amount! : 100000;
      final payBtn = (b.paymentButtonText?.trim().isNotEmpty ?? false)
          ? b.paymentButtonText!.trim()
          : 'To‘lash';
      final payHint = (b.paymentHintText?.trim().isNotEmpty ?? false)
          ? b.paymentHintText!.trim()
          : ((b.hintText?.trim().isNotEmpty ?? false) ? b.hintText!.trim() : 'To‘lov ma’lumotlari');
      final btnBg = _hexForUi(b.paymentButtonColor, p.buttonColor ?? '657DE8');
      final btnFg = _hexForUi(b.paymentButtonTextColor, p.buttonTextColor ?? 'FFFFFF');
      configs.add(
        PaymentConfig.fromModel(
          PaymentModel(
            padding: PaddingModel(left: 16, right: 16, top: 12, bottom: 12),
            amount: amount,
            button: ButtonModel(
              buttonColor: btnBg,
              textColor: btnFg,
              text: payBtn,
              radius: 12,
              padding: PaddingModel(top: 8, bottom: 8, left: 16, right: 16),
              width: 260,
              height: 46,
              alignment: 'center',
              textSize: 14,
              textWeight: 600,
              fontFamily: FontOptions.defaultFont,
            ),
            textField: TextFieldModel(
              padding: PaddingModel(left: 16, right: 16, top: 8, bottom: 8),
              hintText: payHint,
              analyticsFieldsName: _analyticsFieldName(b.analyticsFieldName, 'payment'),
              cornerRadius: 10,
              alignment: 'center',
              textColor: 'E4E4E4',
              backgroundColor: '333333',
              fontWeight: 400,
              fontSize: 16,
              fontFamily: FontOptions.defaultFont,
            ),
            successRedirectUrl: _httpsPaymentUrl(b.successRedirectUrl, '/pay/success'),
            failureCallbackUrl: _httpsPaymentUrl(b.failureCallbackUrl, '/pay/failure'),
            successCallbackUrl: _httpsPaymentUrl(
              b.successCallbackUrl ?? b.successRedirectUrl,
              '/pay/callback',
            ),
          ),
        ),
      );
    default:
      break;
  }
}

List<PageData> pagesFromAiDraft(AiFunnelDraft draft) {
  final pages = <PageData>[];
  for (var i = 0; i < draft.pages.length; i++) {
    final p = draft.pages[i];
    final configs = <BaseConfig>[];

    if (p.content.isNotEmpty) {
      for (final block in p.content) {
        _appendContentBlock(configs, block, p, i, draft);
      }
    } else {
      configs.add(
        ImageConfig(
          fit: BoxFit.cover,
          imageUrl: _resolvePageImageUrl(p, i, draft),
          alignment: Alignment.center,
          height: 200,
          width: 320,
          cornerRadius: 14,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        ),
      );

      final blocks = p.textBlocks.isEmpty
          ? [
              AiTextBlockDraft(text: 'Matn qo‘shilmagan', size: 18, color: 'E4E4E4', weight: 500, alignment: 'center'),
            ]
          : p.textBlocks;

      for (final b in blocks) {
        _appendTextDraft(configs, b);
      }
    }

    final gradientHexes = _normalizeGradientHexes(p);
    final gradientModel = GradientSettingsModel(
      gradientColors: gradientHexes,
      begin: p.gradientBegin ?? 'topCenter',
      end: p.gradientEnd ?? 'bottomCenter',
    );

    final nav = ButtonConfig(
      text: (p.buttonText?.trim().isNotEmpty ?? false) ? p.buttonText!.trim() : 'Davom etish',
      buttonColor: (p.buttonColor ?? '657DE8').toColor,
      textColor: (p.buttonTextColor ?? 'E4E4E4').toColor,
      padding: const EdgeInsets.all(16).copyWith(top: 10),
      radius: 12,
      width: 250,
      height: 42,
      textSize: 14,
      textWeight: TextWeightType.fromModel(500),
      alignment: BasicAlignmentType.fromModel('center'),
      fontFamily: FontOptions.defaultFont,
    );

    pages.add(
      PageData(
        configs: configs,
        pageSettingsConfig: PageSettingsConfig(
          gradientSettings: gradientModel,
          backgroundImage: '',
          scrollable: true,
          backgroundColor: null,
          autoNavigate: false,
          duration: const Duration(milliseconds: 500),
        ),
        navButton: nav,
        pageId: 0,
        pageOrder: i,
      ),
    );
  }
  return pages;
}
