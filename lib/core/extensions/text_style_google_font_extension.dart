import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

extension TextStyleGoogleFontExtension on TextStyle {
  TextStyle withGoogleFont(String? fontFamily) {
    if (fontFamily == null || fontFamily.isEmpty) return this;
    try {
      return GoogleFonts.getFont(fontFamily, textStyle: this);
    } catch (_) {
      return copyWith(fontFamily: fontFamily);
    }
  }
}
