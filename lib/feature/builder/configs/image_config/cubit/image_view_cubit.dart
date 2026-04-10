import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'image_view_state.dart';

class ImageViewCubit extends Cubit<ImageViewState> {
  ImageViewCubit(ImageConfig config) : super(ImageViewState.initial(config));

  void updateImageUrl(String imageUrl) => emit(ImageViewState(config: state.config.copyWith(imageUrl: imageUrl)));

  void updatePadding(EdgeInsets insets) => emit(ImageViewState(config: state.config.copyWith(padding: insets)));

  void updateAlignment(Alignment alignment) =>
      emit(ImageViewState(config: state.config.copyWith(alignment: alignment)));

  void updateHeight(double size) => emit(ImageViewState(config: state.config.copyWith(height: size)));

  void updateWidth(double size) => emit(ImageViewState(config: state.config.copyWith(width: size)));

  void updateFit(BoxFit fit) => emit(ImageViewState(config: state.config.copyWith(fit: fit)));

  void updateCornerRadius(double cornerRadius) =>
      emit(ImageViewState(config: state.config.copyWith(cornerRadius: cornerRadius)));
}
