
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_option_values_model.dart';

class McOptionValuesConfig {
  final String text;
  final String leadingIcon;

  McOptionValuesConfig({
    required this.text,
    required this.leadingIcon,
  });

  factory McOptionValuesConfig.fromModel(McOptionValuesModel model) {
    return McOptionValuesConfig(
      text: model.text ?? 'Option',
      leadingIcon: model.leadingIcon ?? '',
    );
  }

  McOptionValuesModel toModel() {
    return McOptionValuesModel(text: text, leadingIcon: leadingIcon);
  }
}
