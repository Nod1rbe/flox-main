import 'dart:ui';

enum TextWeightType {
  w100(FontWeight.w100, 100),
  w200(FontWeight.w200, 200),
  w300(FontWeight.w300, 300),
  w400(FontWeight.w400, 400),
  w500(FontWeight.w500, 500),
  w600(FontWeight.w600, 600),
  w700(FontWeight.w700, 700),
  w800(FontWeight.w800, 800),
  w900(FontWeight.w900, 900);

  final FontWeight fontWeightValue;
  final int intValue;

  const TextWeightType(this.fontWeightValue, this.intValue);

  static FontWeight fromModel(int weight) {
    return TextWeightType.values
        .firstWhere(
          (e) => e.intValue == weight,
          orElse: () => TextWeightType.w400,
        )
        .fontWeightValue;
  }

  static int toModel(FontWeight fontWeight) {
    return TextWeightType.values
        .firstWhere(
          (e) => e.fontWeightValue == fontWeight,
          orElse: () => TextWeightType.w400,
        )
        .intValue;
  }
}
