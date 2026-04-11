import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/manage_funnel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFunnelButton extends StatefulWidget {
  const AddFunnelButton({super.key});

  @override
  State<AddFunnelButton> createState() => _AddFunnelButtonState();
}

class _AddFunnelButtonState extends State<AddFunnelButton> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            useRootNavigator: true,
            builder: (_) {
              return BlocProvider.value(
                value: context.read<FunnelProjectsBloc>(),
                child: const ManageFunnelDialog(),
              );
            },
          );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isHovering ? 1.02 : 1.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 150),
            offset: _isHovering ? const Offset(0, -0.015) : Offset.zero,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isHovering
                      ? AppColors.primary.withValues(alpha: 0.55)
                      : AppColors.primary.withValues(alpha: 0.32),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 36,
                    color: AppColors.primary.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Yangi funnel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bosib qo‘shing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
