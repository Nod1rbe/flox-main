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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BaseElementButton(
          name: 'Matn',
          icon: const Icon(Icons.text_fields_rounded),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.text);
          },
        ),
        BaseElementButton(
          name: 'Rasm',
          icon: const Icon(Icons.image_outlined),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.image);
          },
        ),
        BaseElementButton(
          name: 'Tanlov',
          icon: const Icon(Icons.checklist_rounded),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.multipleChoice);
          },
        ),
        BaseElementButton(
          name: 'Maydon',
          icon: const Icon(Icons.text_fields_outlined),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.textField);
          },
        ),
        BaseElementButton(
          name: 'Progress',
          icon: const Icon(Icons.linear_scale_rounded),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.progress);
          },
        ),
        BaseElementButton(
          name: "To'lov",
          icon: const Icon(Icons.payments_outlined),
          onTap: () {
            context.read<BuilderCubit>().addComponent(ViewType.payment);
          },
        ),
      ],
    );
  }
}
