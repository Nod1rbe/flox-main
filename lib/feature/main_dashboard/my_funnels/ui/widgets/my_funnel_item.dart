import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/links_view_dialog.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/manage_funnel_dialog.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyFunnelItem extends StatefulWidget {
  final Function() onTap;
  final FunnelProjectsModel funnel;
  const MyFunnelItem({
    super.key,
    required this.onTap,
    required this.funnel,
  });

  @override
  State<MyFunnelItem> createState() => _MyFunnelItemState();
}

class _MyFunnelItemState extends State<MyFunnelItem> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isHovering ? 1.02 : 1.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 150),
            offset: _isHovering ? const Offset(0, -0.015) : Offset.zero,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 14),
              decoration: BoxDecoration(
                color: AppColors.layoutBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isHovering
                      ? AppColors.primary.withValues(alpha: 0.45)
                      : AppColors.dividerColor.withValues(alpha: 0.75),
                  width: 1,
                ),
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 20,
                          spreadRadius: -2,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.funnel.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.funnel.description ?? '',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.subtitle,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _actionIcon(
                            onTap: () {
                              showDialog(
                                context: context,
                                useRootNavigator: true,
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: context.read<FunnelProjectsBloc>(),
                                    child: ManageFunnelDialog(
                                      name: widget.funnel.name,
                                      description: widget.funnel.description,
                                      id: widget.funnel.id,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Assets.icons.edit,
                          ),
                          const SizedBox(height: 4),
                          if (widget.funnel.links.isNotEmpty)
                            _actionIcon(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (context) {
                                    return LinksViewDialog(links: widget.funnel.links);
                                  },
                                );
                              },
                              icon: Assets.icons.link,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
                        ),
                        child: Text(
                          '${widget.funnel.pageIds.length} sahifa',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          DateFormat('dd MMM yyyy').format(widget.funnel.createdAt ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.subtitle,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionIcon({
    required Function() onTap,
    required SvgGenImage icon,
  }) {
    return TappableComponent(
      onTap: onTap,
      borderRadius: 8,
      hoverColor: AppColors.primary.withValues(alpha: 0.12),
      child: SizedBox(
        height: 32,
        width: 32,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: icon.svg(
            colorFilter: ColorFilter.mode(
              AppColors.primary.withValues(alpha: 0.92),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
