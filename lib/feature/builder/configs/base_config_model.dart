import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/image_config/model/image_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/payment_config/model/payment_model.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/text_config/model/text_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';

abstract class BaseConfigModel {
  factory BaseConfigModel.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];
    if (type == ViewType.image.name) {
      return ImageModel.fromJson(json);
    } else if (type == ViewType.text.name) {
      return TextModel.fromJson(json);
    } else if (type == ViewType.textField.name) {
      return TextFieldModel.fromJson(json);
    } else if (type == ViewType.button.name) {
      return ButtonModel.fromJson(json);
    } else if (type == ViewType.progress.name) {
      return ProgressModel.fromJson(json);
    } else if (type == ViewType.multipleChoice.name) {
      return MultipleChoiceModel.fromJson(json);
    } else if(type == ViewType.payment.name) {
      return PaymentModel.fromJson(json);
    } else {
      throw UnsupportedError('Unsupported widget type: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson();

  late final String type;
}
