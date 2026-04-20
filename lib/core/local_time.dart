import 'package:intl/intl.dart';

class LocalTime {
  DateTime date = DateTime.now();
  String get today => formatOrdinalLong(date);
  String get todayWithoutSuffix => '${date.day} ${DateFormat('MMMM').format(date)} ${date.year}';
  String get todayWithMonth => '${DateFormat('EEEE').format(date)} ${date.day}${getDaySuffix(date.day)} ${DateFormat('MMMM').format(date)}';
  String get militaryTimeH => '${date.hour}';
  String get militaryTimeM => '${date.minute}';
  String get standardTime => DateFormat('hh:mm').format(date);

  String formatOrdinalLong(DateTime date) {
    final day = date.day;
    final suffix = getDaySuffix(day);
    final month = DateFormat('MMMM').format(date);
    final year = date.year;

    return '$day$suffix $month $year';
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }

  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}