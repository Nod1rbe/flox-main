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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isHovering
              ? (Matrix4.identity()
                ..translate(0.0, -4.0, 0.0)
                ..scale(1.02))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 34,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 10),
              Text(
                'Add New Funnel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
