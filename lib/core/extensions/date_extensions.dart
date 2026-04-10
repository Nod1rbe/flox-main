import 'package:intl/intl.dart';

extension DateFormattingExtension on DateTime {
  String get formattedDate {
    return DateFormat('MMMM d, y').format(toLocal());
  }
}
