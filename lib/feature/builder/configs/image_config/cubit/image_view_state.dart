part of 'image_view_cubit.dart';

final class ImageViewState {
  final ImageConfig config;

  ImageViewState({required this.config});

  factory ImageViewState.initial(ImageConfig config) => ImageViewState(config: config);
}
