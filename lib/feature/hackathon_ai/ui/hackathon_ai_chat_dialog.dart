import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/openai/openai_chat_service.dart';
import 'package:flox/core/openai/openai_env.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/builder/repositories/builder_repository.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flox/feature/hackathon_ai/ai_funnel_draft_mapper.dart';
import 'package:flox/feature/hackathon_ai/ai_funnel_draft_parser.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/repository/funnels_projects_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Hackathon: savollar + oxirida `floxDraft` JSON, builderda ochish.
class HackathonAiChatDialog extends StatefulWidget {
  const HackathonAiChatDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const HackathonAiChatDialog(),
    );
  }

  @override
  State<HackathonAiChatDialog> createState() => _HackathonAiChatDialogState();
}

class _HackathonAiChatDialogState extends State<HackathonAiChatDialog> {
  final _service = OpenAiChatService();
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_ChatLine> _lines = [];
  final List<Map<String, String>> _apiHistory = [];

  bool _loading = false;
  bool _applying = false;

  List<PageData>? _readyPages;
  String? _readyFunnelName;

  static const _systemPrompt = '''
Sen Flox funnel builder yordamchisisan. Odatda o‘zbekcha yoz.

**Savollar (qat’iy):** Faqat ikki mavzuda so‘ra: (1) qanday biznes / nima taklif qilmoqchi, (2) asosiy auditoriya kimlar.
Rang, shrift, "dizayn qanday bo‘lsin", vizual uslub haqida **hech qachon** so‘rama — bularni o‘zing professional tarzda tanlaysan.

**Generatsiya (qat’iy):** Biznes va auditoriya aniq bo‘lgach (yoki foydalanuvchi tayyorlik bildirsa yoki pastdagi tugma bosilsa) — **bitta** assistant xabarda **barcha** sahifalarni chiqar.
Sahifalarni alohida-alohida xabarlarda **yuborma**. Har doim **bitta** ```json kod bloki** ichida yakuniy `floxDraft` bo‘lsin.

`floxDraft.pages` massivida **aynan 5 yoki 6 ta** element bo‘lsin (kamroq yoki ko‘proq qabul qilinmaydi — tuzatib qayta yoz).
Har bir sahifa uchun:
- **Sahifa foni faqat gradient:** `gradientColors` massivida **kamida 2 ta** 6 xonali hex (`#` siz); 3–4 ta rang bo‘lishi mumkin. Oddiy bir rangli `backgroundColor` bilan fon **ishlatilmaydi** — uni yozma yoki e’tiborsiz qoldir. Ixtiyoriy `gradientBegin` / `gradientEnd`: `topCenter`, `bottomCenter`, `centerLeft`, `centerRight`, `topLeft`, `topRight`, `bottomLeft`, `bottomRight`, `center`.
- Matn `color` va tugma ranglari: 6 belgili hex, `#` siz.
- **Sahifa mazmuni (qat’iy):** Har bir sahifada **`content`** massivi — tartib bilan bloklar. Har bir elementda **`type`**: `text` | `image` | `textField` | `multipleChoice` | `progress` | `payment`.
- **Mantiqiy tuzilish (qat’iy):** Har sahifa uchun **maqsadni** tanla va faqat kerakli bloklarni qo‘y — barcha turlarni har sahifaga yig‘ma.
  - **Ma’lumot yig‘ish** kerak bo‘lgan sahifada: `textField` (email, telefon, ism va hokazo) va/yoki `multipleChoice` (segment, tanlov, “qaysi xizmat”); bir sahifada ikkalasi ham bo‘lishi mumkin, lekin **faqat** yig‘ish uchun kerak bo‘lsa.
  - **Faqat ko‘rsatadigan** sahifa (tanishuv, afzalliklar, ishonch, “keyingi qadam”): asosan `text`, `image`, kerak bo‘lsa `progress` (kutish / tayyorlash / “tahlil qilinyapti” effekti); `textField` va `multipleChoice` shu sahifada **qo‘yma** (agar alohida mini-so‘rovsiz).
  - **To‘lov** kerak bo‘lsa: funnel oxiriga yaqin **1 yoki 2** ta sahifada `type: "payment"`; `amount` (butun son — narxdagi `Payment.amount` maydoni bilan bir xil), `paymentHintText`, `paymentButtonText`, ixtiyoriy `paymentButtonColor` / `paymentButtonTextColor` (6 xonali hex, `#` siz; ko‘pincha sahifa `buttonColor` / `buttonTextColor` bilan **mavzuga mos** qilib bir xil palitra tanla). Callback URL lar: haqiqiy URL bo‘lmasa, `https://example.com/...` kabi to‘g‘ri **https** placeholder yoz (keyin loyihada almashtiriladi).
  - **Umumiy:** har sahifada odatda kamida **1** ta `image` va kamida **1–2** ta `text` (kontekst + CTA); `progress`ni asosan o‘tish, kutish, “natija tayyorlanmoqda” kabi sahifalarda ishlat. Funnel bo‘ylab bloklarni **mavzuga mos tartibda** joylashtir: avval kontekst matn va rasm, keyin savol/yig‘ish, keyin progress yoki to‘lov.
  - `text`: `text`, `size`, `color`, `weight`, `alignment`.
  - `image`: `imageTags` (inglizcha), ixtiyoriy `pageImageHint`, ixtiyoriy `imageUrl` (faqat ishonchli domenlar).
  - `textField`: `hintText`, ixtiyoriy `analyticsFieldName`.
  - `multipleChoice`: `question`, `options` (kamida 2 ta), ixtiyoriy `analyticsFieldName`.
  - `progress`: `progressSteps` — `[{ "label": "...", "duration": 1.6 }, ...]`; `duration` sekund (taxminan 0.8–2.5).
- **Rasm / mavzu (qat’iy):** `floxDraft` ildizida **`businessImageTags`** bo‘lsin — kamida **3 ta** inglizcha kalit (butun biznes niqobi, masalan `["coffee","espresso","cafe"]`). Har bir sahifadagi `content` ichidagi `image` bloklarida **`imageTags`** shu sahifa mazmuniga mos, **boshqa sahifadan takrorlanmasin**. Ixtiyoriy **`pageImageHint`**: inglizcha qisqa ibora. **`imageUrl`** faqat haqiqiy mavzuga yaqin rasm bo‘lsa: `images.unsplash.com`, `pexels.com`, `pixabay.com`, `wikimedia.org` — `picsum.photos` yoki placeholder saytlar **ishlatma**.
- Eski usul (`textBlocks` + sahifa darajasidagi rasm) faqat **`content` bo‘lmaganda** qo‘llanadi — yangi JSONda **`content` ishlat**.
- `funnelName`: qisqa nom.

Misol struktura (pages ichida 5 yoki 6 ta shu ko‘rinishda obyekt qo‘sh):

```json
{
  "floxDraft": {
    "version": 1,
    "funnelName": "Misollar Coffee",
    "businessImageTags": ["coffee","espresso","cafe","barista"],
    "pages": [
      {
        "gradientColors": ["1A1A2E", "0F3460", "533483"],
        "gradientBegin": "topCenter",
        "gradientEnd": "bottomCenter",
        "content": [
          { "type": "text", "text": "Yangi ta’m", "size": 28, "color": "EAEAEA", "weight": 700, "alignment": "center" },
          { "type": "image", "imageTags": ["latte","art","steam"], "pageImageHint": "barista pouring latte art" },
          { "type": "text", "text": "Shahar markazida.", "size": 16, "color": "B8B8B8", "weight": 400, "alignment": "center" },
          {
            "type": "progress",
            "progressSteps": [
              { "label": "Analyzing your choice", "duration": 1.6 },
              { "label": "Preparing recommendations", "duration": 1.3 }
            ]
          }
        ],
        "buttonText": "Keyingi",
        "buttonColor": "4E54C8",
        "buttonTextColor": "FFFFFF"
      }
    ]
  }
}
```

Yana: **yig‘ish** sahifasida `textField` / `multipleChoice` qo‘sh; **to‘lov** sahifasida masalan `{ "type": "payment", "amount": 99000, "paymentHintText": "Karta yoki to‘lov usuli", "paymentButtonText": "To‘lash", "paymentButtonColor": "4E54C8", "paymentButtonTextColor": "FFFFFF", "successRedirectUrl": "https://example.com/success", "failureCallbackUrl": "https://example.com/failure", "successCallbackUrl": "https://example.com/callback" }` (URL lar keyin real domen bilan almashtiriladi).

Eslatma: yuqoridagi `pages` faqat 1 ta misol — sen **5 yoki 6 ta** to‘liq sahifa bilan to‘ldirasan.
''';

  static const _bootstrapUserText = '''
Chat ochildi. Salom qil va faqat ikkita narsani so‘ra: (1) qanday biznes / nima sotadi yoki taklif qiladi, (2) asosiy mijozlar / auditoriya kimlar.
Rang, shrift yoki dizayn haqida so‘rama. JSON chiqarma — hozircha faqat bu ikki savol.
''';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ingestAssistantReply(String reply) {
    final draft = tryParseFloxDraft(reply);
    if (draft == null) return;
    final n = draft.pages.length;
    if (n != 5 && n != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'JSONda $n ta sahifa. Aynan 5 yoki 6 ta bo‘lishi kerak. "5–6 sahifa JSON yarat" yoki tayyorlik xabarini qayta yuboring.',
            ),
          ),
        );
      }
      return;
    }
    if (draft.businessImageTags.length < 3) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'floxDraft.businessImageTags kamida 3 ta inglizcha kalit bo‘lishi kerak (butun biznes uchun). JSONni qayta yuboring.',
            ),
          ),
        );
      }
      return;
    }
    if (!isValidDraftPageGradients(draft)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Har sahifada gradientColors: kamida 2 ta 6 xonali hex (# siz). Oddiy backgroundColor bilan fon qabul qilinmaydi.',
            ),
          ),
        );
      }
      return;
    }
    if (!isDraftContentPagesConsistent(draft)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Agar `content` ishlatilsa, har bir sahifada (5 yoki 6 tada) `content` bo‘lishi kerak. Bo‘sh sahifa yoki faqat `textBlocks` qolmasin.',
            ),
          ),
        );
      }
      return;
    }
    setState(() {
      _readyFunnelName = draft.funnelName;
      _readyPages = pagesFromAiDraft(draft);
    });
  }

  Future<void> _bootstrap() async {
    if (!OpenAiEnv.hasApiKey) {
      if (!mounted) return;
      setState(() {
        _lines.add(
          _ChatLine(
            role: _Role.error,
            text:
                "OPENAI_API_KEY topilmadi. lib/core/openai/openai_hackathon_key.dart ichida kOpenAiHackathonInlineKey ga kalit yozing, yoki .env / PowerShell / --dart-define ishlating — so'ng ilovani to'liq qayta ishga tushiring.",
          ),
        );
      });
      return;
    }

    setState(() => _loading = true);
    _scrollToEnd();

    try {
      final reply = await _service.completeChat(
        messages: [
          {'role': 'system', 'content': _systemPrompt},
          {'role': 'user', 'content': _bootstrapUserText},
        ],
      );
      if (!mounted) return;
      setState(() {
        _apiHistory.addAll([
          {'role': 'user', 'content': _bootstrapUserText},
          {'role': 'assistant', 'content': reply},
        ]);
        _lines.add(_ChatLine(role: _Role.assistant, text: reply));
        _ingestAssistantReply(reply);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _lines.add(_ChatLine(role: _Role.error, text: e.toString()));
        _loading = false;
      });
    }
    _scrollToEnd();
  }

  Future<void> _sendUserText(String text) async {
    if (text.isEmpty || _loading) return;

    setState(() {
      _lines.add(_ChatLine(role: _Role.user, text: text));
      _loading = true;
    });
    _scrollToEnd();

    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
        ..._apiHistory,
        {'role': 'user', 'content': text},
      ];

      final reply = await _service.completeChat(messages: messages);
      if (!mounted) return;
      setState(() {
        _apiHistory.addAll([
          {'role': 'user', 'content': text},
          {'role': 'assistant', 'content': reply},
        ]);
        _lines.add(_ChatLine(role: _Role.assistant, text: reply));
        _ingestAssistantReply(reply);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _lines.add(_ChatLine(role: _Role.error, text: e.toString()));
        _loading = false;
      });
    }
    _scrollToEnd();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _loading) return;
    _input.clear();
    await _sendUserText(text);
  }

  Future<void> _requestDraftGeneration() async {
    await _sendUserText(
      'Tayyor: biznes va auditoriya berilgan deb hisobla. Endi bitta ```json``` blok: floxDraft — businessImageTags (kamida 3), 5–6 sahifa, har sahifada gradientColors (kamida 2 hex), matnga mos imageTags, ixtiyoriy pageImageHint; imageUrl faqat unsplash/pexels/pixabay/wikimedia. Sahifa fonida oddiy backgroundColor ishlatma.',
    );
  }

  Future<void> _applyDraft() async {
    final pages = _readyPages;
    if (pages == null || pages.isEmpty || _applying) return;

    setState(() => _applying = true);
    try {
      final repo = getIt<FunnelsProjectsRepository>();
      final name = (_readyFunnelName?.trim().isNotEmpty ?? false) ? _readyFunnelName!.trim() : 'AI funnel';
      final Either<String, FunnelProjectsModel> created =
          await repo.createFunnel(name: name, description: 'AI (hackathon)');

      if (!mounted) return;

      await created.fold<Future<void>>(
        (err) async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        },
        (FunnelProjectsModel funnel) async {
          final id = funnel.id;
          if (id == null || id.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funnel id yo‘q')),
            );
            return;
          }
          final upload = await getIt<BuilderRepository>().uploadFunnel(pages: pages, funnelId: id);
          if (!mounted) return;
          await upload.fold<Future<void>>(
            (err) async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
            },
            (_) async {
              try {
                context.read<FunnelProjectsBloc>().add(GetFunnelsEvent());
              } catch (_) {}
              Navigator.of(context).pop();
              await context.router.push(
                BuilderRoute(
                  funnelId: id,
                  isEditing: true,
                  funnelName: name,
                ),
              );
            },
          );
        },
      );
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.layoutBackground,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'AI funnel (hackathon)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Text(
                'Faqat biznes + auditoriya. JSONda businessImageTags + sahifaga mos imageTags (mavzuga yaqin rasm).',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  OutlinedButton(
                    onPressed: (_loading || _applying) ? null : _requestDraftGeneration,
                    child: Text(
                      '5–6 sahifa JSON yarat',
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                  if (_readyPages != null && _readyPages!.isNotEmpty)
                    FilledButton(
                      onPressed: _applying ? null : _applyDraft,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondaryAccent,
                        foregroundColor: AppColors.white,
                      ),
                      child: _applying
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                            )
                          : Text('Builderda ochish (${_readyPages!.length} sahifa)'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.pageBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: _lines.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_loading && index == _lines.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Text('Thinking…', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ],
                          ),
                        );
                      }
                      final line = _lines[index];
                      final isUser = line.role == _Role.user;
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.primary.withValues(alpha: 0.25) : AppColors.cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SelectableText(
                            line.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: line.role == _Role.error ? AppColors.softError : AppColors.white,
                              height: 1.35,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      style: TextStyle(color: AppColors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Javobingiz…',
                        hintStyle: TextStyle(color: AppColors.hintText),
                        filled: true,
                        fillColor: AppColors.pageBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _loading ? null : _send,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text('Yuborish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Role { user, assistant, error }

class _ChatLine {
  _ChatLine({required this.role, required this.text});

  final _Role role;
  final String text;
}
