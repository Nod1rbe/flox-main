import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/image_config/cubit/image_view_cubit.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageConfigWidget extends StatelessWidget {
  const ImageConfigWidget({super.key, required this.config, required this.isSelected});

  final ImageConfig config;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageViewCubit, ImageViewState>(
      listener: (BuildContext context, ImageViewState state) {
        debugPrint('ImageConfig widget updated: ${state.config.toString()}');
        context.read<BuilderCubit>().updateSelectedConfig(state.config);
      },
      child: Stack(children: [
        if (isSelected)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        Container(
          padding: config.padding,
          alignment: config.alignment,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(config.cornerRadius),
            child: Image.network(
              fit: config.fit,
              config.imageUrl,
              height: config.height,
              width: config.width,
            ),
          ),
        ),
      ]),
    );
  }
}
