import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/ui_components/components/atoms/button_atom.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flutter/material.dart';

class ConfirmExitDialog extends StatelessWidget {
  const ConfirmExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
          maxHeight: 400,
        ),
        child: BaseContainerComponent(
          padding: EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            children: [
              const Spacer(),
              Assets.icons.infoRedRounded.svg(),
              const SizedBox(height: 10),
              const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to exit the game?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ButtonAtom(
                      text: 'Cancel',
                      color: AppColors.white,
                      textColor: AppColors.black,
                      borderRadius: 6,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ButtonAtom(
                      text: 'Exit',
                      color: AppColors.softError,
                      textColor: AppColors.white,
                      borderRadius: 6,
                      onTap: () => Navigator.pop(context),
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
}
