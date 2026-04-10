import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksViewDialog extends StatefulWidget {
  final List<String> links;

  const LinksViewDialog({super.key, required this.links});

  @override
  State<LinksViewDialog> createState() => _LinksViewDialogState();
}

class _LinksViewDialogState extends State<LinksViewDialog> {
  String _getUrlFor(String source) {
    return widget.links.firstWhere(
      (link) => link.contains('source=$source'),
      orElse: () => '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 520,
        ),
        child: BaseContainerComponent(
          padding: EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Share Your Funnel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).topCenter,
              const SizedBox(height: 16),
              _linkItem(
                icon: Assets.icons.instagramLogo,
                label: 'Instagram',
                url: _getUrlFor('instagram'),
              ),
              _linkItem(
                icon: Assets.icons.telegramLogo,
                label: 'Telegram',
                url: _getUrlFor('telegram'),
              ),
              _linkItem(
                icon: Assets.icons.xLogo,
                label: 'X',
                url: _getUrlFor('x'),
              ),
              _linkItem(
                icon: Assets.icons.facebookLogo,
                label: 'Facebook',
                url: _getUrlFor('facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkItem({
    required SvgGenImage icon,
    required String label,
    required String url,
  }) {
    return Card(
      color: AppColors.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TappableComponent(
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11, top: 12, bottom: 12),
          child: Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: icon.svg(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      url,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TappableComponent(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label link copied!')),
                  );
                },
                borderRadius: 8,
                hoverColor: AppColors.primary.withValues(alpha: 0.12),
                splashColor: AppColors.primary.withValues(alpha: 0.2),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Assets.icons.copy.svg(height: 20, width: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
