/// Sahifa ichidagi tartibli blok (`pagesFromAiDraft` da map qilinadi).
class AiPageContentBlock {
  AiPageContentBlock({
    required this.type,
    this.text,
    this.size,
    this.color,
    this.weight,
    this.alignment,
    this.imageUrl,
    this.imageTags = const [],
    this.pageImageHint,
    this.hintText,
    this.analyticsFieldName,
    this.question,
    this.options = const [],
    this.progressSteps = const [],
    this.amount,
    this.paymentButtonText,
    this.paymentHintText,
    this.paymentButtonColor,
    this.paymentButtonTextColor,
    this.successRedirectUrl,
    this.failureCallbackUrl,
    this.successCallbackUrl,
  });

  /// `text` | `image` | `textField` | `multipleChoice` | `progress` | `payment`
  final String type;

  /// `text` / `multipleChoice.question` oldidagi matn
  final String? text;
  final double? size;
  final String? color;
  final int? weight;
  final String? alignment;

  final String? imageUrl;
  final List<String> imageTags;
  final String? pageImageHint;

  final String? hintText;
  final String? analyticsFieldName;

  /// `multipleChoice` uchun ixtiyoriy savol (bo‘lsa alohida [TextConfig] qo‘shiladi).
  final String? question;
  final List<String> options;

  final List<AiProgressStepDraft> progressSteps;

  /// `payment` — [PaymentModel.amount] bilan bir xil maydon (butun son).
  final int? amount;

  final String? paymentButtonText;
  final String? paymentHintText;
  final String? paymentButtonColor;
  final String? paymentButtonTextColor;

  final String? successRedirectUrl;
  final String? failureCallbackUrl;
  final String? successCallbackUrl;

  String get normalizedKind =>
      type.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');

  factory AiPageContentBlock.fromJson(Map<String, dynamic> json) {
    final typeRaw = (json['type'] ?? json['kind'] ?? 'text').toString();
    final options = <String>[];
    final optRaw = json['options'] ?? json['choices'];
    if (optRaw is List) {
      for (final e in optRaw) {
        if (e is String && e.trim().isNotEmpty) options.add(e.trim());
      }
    }
    final tags = <String>[];
    final tagsRaw = json['imageTags'];
    if (tagsRaw is List) {
      for (final e in tagsRaw) {
        if (e is String && e.trim().isNotEmpty) tags.add(e.trim());
      }
    }
    final steps = <AiProgressStepDraft>[];
    final stepsRaw = json['progressSteps'] ?? json['steps'];
    if (stepsRaw is List) {
      for (final e in stepsRaw) {
        if (e is Map<String, dynamic>) {
          steps.add(AiProgressStepDraft.fromJson(e));
        } else if (e is Map) {
          steps.add(AiProgressStepDraft.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final amtRaw = json['amount'];
    int? amount;
    if (amtRaw is num) {
      amount = amtRaw.round();
    } else if (amtRaw is String && amtRaw.trim().isNotEmpty) {
      amount = int.tryParse(amtRaw.trim());
    }
    return AiPageContentBlock(
      type: typeRaw,
      text: json['text'] as String?,
      size: (json['size'] as num?)?.toDouble(),
      color: json['color'] as String?,
      weight: (json['weight'] as num?)?.toInt(),
      alignment: json['alignment'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageTags: tags,
      pageImageHint: json['pageImageHint'] as String?,
      hintText: json['hintText'] as String?,
      analyticsFieldName: json['analyticsFieldName'] as String?,
      question: json['question'] as String?,
      options: options,
      progressSteps: steps,
      amount: amount,
      paymentButtonText: json['paymentButtonText'] as String?,
      paymentHintText: json['paymentHintText'] as String?,
      paymentButtonColor: json['paymentButtonColor'] as String?,
      paymentButtonTextColor: json['paymentButtonTextColor'] as String?,
      successRedirectUrl: json['successRedirectUrl'] as String?,
      failureCallbackUrl: json['failureCallbackUrl'] as String?,
      successCallbackUrl: json['successCallbackUrl'] as String?,
    );
  }
}

class AiProgressStepDraft {
  AiProgressStepDraft({required this.label, required this.duration});

  final String label;
  final double duration;

  factory AiProgressStepDraft.fromJson(Map<String, dynamic> json) {
    final label = (json['label'] ?? json['text'] ?? json['t'] ?? '').toString();
    final d = (json['duration'] as num?)?.toDouble() ??
        (json['d'] as num?)?.toDouble() ??
        1.5;
    return AiProgressStepDraft(label: label, duration: d > 0.2 ? d : 0.2);
  }
}

/// AI chiqaradigan soddalashtirilgan funnel (keyin [PageData] ga map qilinadi).
class AiFunnelDraft {
  AiFunnelDraft({
    required this.version,
    required this.funnelName,
    required this.pages,
    this.businessImageTags = const [],
  });

  final int version;
  final String funnelName;
  final List<AiFunnelPageDraft> pages;

  /// Butun funnel uchun stock qidiruv teglari (inglizcha, biznesga bog‘liq).
  final List<String> businessImageTags;

  factory AiFunnelDraft.fromJson(Map<String, dynamic> json) {
    final root = (json['floxDraft'] as Map<String, dynamic>?) ?? json;
    final pagesRaw = root['pages'];
    final pages = <AiFunnelPageDraft>[];
    if (pagesRaw is List) {
      for (final e in pagesRaw) {
        if (e is Map<String, dynamic>) {
          pages.add(AiFunnelPageDraft.fromJson(e));
        } else if (e is Map) {
          pages.add(AiFunnelPageDraft.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final nameRaw = root['funnelName'] ?? root['name'] ?? 'AI funnel';
    final bizRaw = root['businessImageTags'];
    final biz = <String>[];
    if (bizRaw is List) {
      for (final e in bizRaw) {
        if (e is String && e.trim().isNotEmpty) biz.add(e.trim());
      }
    }
    return AiFunnelDraft(
      version: (root['version'] as num?)?.toInt() ?? 1,
      funnelName: nameRaw is String ? nameRaw : nameRaw.toString(),
      pages: pages,
      businessImageTags: biz,
    );
  }
}

class AiFunnelPageDraft {
  AiFunnelPageDraft({
    required this.backgroundColor,
    required this.textBlocks,
    this.content = const [],
    this.gradientColors = const [],
    this.gradientBegin,
    this.gradientEnd,
    this.imageUrl,
    this.imageTags = const [],
    this.pageImageHint,
    this.buttonText,
    this.buttonColor,
    this.buttonTextColor,
  });

  final String backgroundColor;
  final List<AiTextBlockDraft> textBlocks;

  /// Bo‘sh bo‘lmasa — sahifa tartibi shu bloklar bo‘yicha quriladi (`text`, `image`, `textField`, …).
  final List<AiPageContentBlock> content;

  /// Kamida 2 ta 6 belgili hex (`#` siz) bo‘lsa — fon uchun gradient ishlatiladi.
  final List<String> gradientColors;

  /// Masalan: `topCenter`, `bottomCenter`, `centerLeft` (LinearGradient begin).
  final String? gradientBegin;

  /// Masalan: `bottomCenter`, `bottomRight`.
  final String? gradientEnd;

  /// To‘g‘ridan-to‘g‘ri https rasm URL (ustuvor).
  final String? imageUrl;

  /// Bo‘sh bo‘lsa yoki URL ishlamasa — loremflickr uchun teglar (masalan: ["coffee","shop"]).
  final List<String> imageTags;

  /// Sahifa mazmuniga mos rasm qidiruvi (inglizcha qisqa, masalan "barista pouring espresso").
  final String? pageImageHint;

  final String? buttonText;
  final String? buttonColor;
  final String? buttonTextColor;

  factory AiFunnelPageDraft.fromJson(Map<String, dynamic> json) {
    final blocksRaw = json['textBlocks'];
    final blocks = <AiTextBlockDraft>[];
    if (blocksRaw is List) {
      for (final e in blocksRaw) {
        if (e is Map<String, dynamic>) {
          blocks.add(AiTextBlockDraft.fromJson(e));
        } else if (e is Map) {
          blocks.add(AiTextBlockDraft.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final contentRaw = json['content'];
    final content = <AiPageContentBlock>[];
    if (contentRaw is List) {
      for (final e in contentRaw) {
        if (e is Map<String, dynamic>) {
          content.add(AiPageContentBlock.fromJson(e));
        } else if (e is Map) {
          content.add(AiPageContentBlock.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final tagsRaw = json['imageTags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final e in tagsRaw) {
        if (e is String && e.trim().isNotEmpty) tags.add(e.trim());
      }
    }
    final gradRaw = json['gradientColors'];
    final grad = <String>[];
    if (gradRaw is List) {
      for (final e in gradRaw) {
        if (e is String && e.trim().isNotEmpty) {
          grad.add(e.replaceAll('#', '').trim());
        }
      }
    }
    return AiFunnelPageDraft(
      backgroundColor: (json['backgroundColor'] ?? json['bg'] ?? '1E1E1E') as String,
      textBlocks: blocks,
      content: content,
      gradientColors: grad,
      gradientBegin: json['gradientBegin'] as String?,
      gradientEnd: json['gradientEnd'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imageTags: tags,
      pageImageHint: json['pageImageHint'] as String?,
      buttonText: json['buttonText'] as String?,
      buttonColor: json['buttonColor'] as String?,
      buttonTextColor: json['buttonTextColor'] as String?,
    );
  }
}

class AiTextBlockDraft {
  AiTextBlockDraft({
    required this.text,
    this.size,
    this.color,
    this.weight,
    this.alignment,
  });

  final String text;
  final double? size;
  final String? color;
  final int? weight;
  final String? alignment;

  factory AiTextBlockDraft.fromJson(Map<String, dynamic> json) {
    return AiTextBlockDraft(
      text: (json['text'] ?? '') as String,
      size: (json['size'] as num?)?.toDouble(),
      color: json['color'] as String?,
      weight: (json['weight'] as num?)?.toInt(),
      alignment: json['alignment'] as String?,
    );
  }
}
