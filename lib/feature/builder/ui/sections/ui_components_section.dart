import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/ui_components/elements/base_element_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UIComponentsSection extends StatelessWidget {
  const UIComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BaseElementButton(
          name: 'Text',
          icon: Icon(Icons.text_fields, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.text);
          },
        ),
        BaseElementButton(
          name: 'Image',
          icon: Icon(Icons.image, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.image);
          },
        ),
        BaseElementButton(
          name: 'Multiple Choice',
          icon: Icon(Icons.check_box, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.multipleChoice);
          },
        ),
        BaseElementButton(
          name: 'Text Field',
          icon: Icon(Icons.font_download, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.textField);
          },
        ),
        BaseElementButton(
          name: 'Progress Bar',
          icon: Icon(Icons.linear_scale, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.progress);
          },
        ),
        BaseElementButton(
          name: 'Subscription\nOptions',
          icon: Icon(Icons.attach_money, color: AppColors.white),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.payment);
          },
        ),
      ],
    );
  }
}
