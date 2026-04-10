import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flutter/cupertino.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets fromPaddingModel(PaddingModel? paddingModel) {
    return EdgeInsets.only(
      left: paddingModel?.left ?? 8,
      top: paddingModel?.top ?? 8,
      right: paddingModel?.right?? 8,
      bottom: paddingModel?.bottom ?? 8,
    );
  }

  EdgeInsets changeLeft(double left) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  EdgeInsets changeRight(double right) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  EdgeInsets changeBottom(double bottom) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  EdgeInsets changeTop(double top) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

}
