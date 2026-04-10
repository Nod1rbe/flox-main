import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/image_config/image_config.dart';
import 'package:flox/feature/builder/configs/image_config/model/image_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flox/feature/builder/configs/payment_config/model/payment_model.dart';
import 'package:flox/feature/builder/configs/payment_config/payment_config.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/feature/builder/configs/text_config/model/text_model.dart';
import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseConfig {
  final ViewType type;
  final EdgeInsets padding;

  BaseConfig({
    required this.type,
    required this.padding,
  });

  factory BaseConfig.fromModel(BaseConfigModel model) {
    if (model.type == ViewType.text.name) {
      return TextConfig.fromModel(model as TextModel);
    } else if (model.type == ViewType.textField.name) {
      return TextFieldConfig.fromModel(model as TextFieldModel);
    } else if (model.type == ViewType.image.name) {
      return ImageConfig.fromModel(model as ImageModel);
    } else if (model.type == ViewType.button.name) {
      return ButtonConfig.fromModel(model as ButtonModel);
    } else if (model.type == ViewType.progress.name) {
      return ProgressConfig.fromModel(model as ProgressModel);
    } else if (model.type == ViewType.multipleChoice.name) {
      return MultipleChoiceConfig.fromModel(model as MultipleChoiceModel);
    } else if (model.type == ViewType.payment.name) {
      return PaymentConfig.fromModel(model as PaymentModel);
    } else {
      throw UnsupportedError('Unsupported module type: ${model.type}');
    }
  }

  Widget toWidget(bool isSelected, {Key? key});

  BaseConfigModel toModel();

  @override
  String toString() {
    return 'BaseConfig{type: $type, padding: $padding}';
  }
}

enum ViewType {
  text('text'),
  textField('textField'),
  image('image'),
  button('button'),
  progress('progress'),
  multipleChoice('multipleChoice'),
  payment('payment');

  final String name;

  const ViewType(this.name);
}
