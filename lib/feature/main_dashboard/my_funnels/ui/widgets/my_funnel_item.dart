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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isHovering
              ? (Matrix4.identity()
                ..translate(0.0, -4.0, 0.0)
                ..scale(1.02))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16, bottom: 16, right: 9, top: 9),
          decoration: BoxDecoration(
            color: AppColors.layoutBackground,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: AppColors.layoutBackground.withValues(alpha: 0.25),
                      blurRadius: 12.0,
                      spreadRadius: 1,
                      offset: const Offset(0, 4.0),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2.0),
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
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.funnel.description ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
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
                      color: AppColors.secondaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${widget.funnel.pageIds.length} Pages',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(widget.funnel.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightGrey.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
      borderRadius: 6,
      hoverColor: AppColors.defaultSplashColor,
      child: SizedBox(
        height: 30,
        width: 30,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: icon.svg(
            colorFilter: ColorFilter.mode(
              AppColors.secondaryAccent,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
