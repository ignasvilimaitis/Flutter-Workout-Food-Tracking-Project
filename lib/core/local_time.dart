import 'package:intl/intl.dart';

class LocalTime {
DateTime date = DateTime.now();
String get today => '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';
String get militaryTimeH => '${date.hour}';
String get militaryTimeM => '${date.minute}';
String get currentDate => DateFormat('yyyy-MM-dd').format(date);

String getPreviousDate(String currentDate) {
  DateTime parsedDate = DateTime.parse(currentDate);
  DateTime previousDate = parsedDate.subtract(Duration(days: 1));
  return DateFormat('yyyy-MM-dd').format(previousDate);

}

String getAheadDate(String currentDate) {
  DateTime parsedDate = DateTime.parse(currentDate);
  DateTime aheadDate = parsedDate.add(Duration(days: 1));
  return DateFormat('yyyy-MM-dd').format(aheadDate);

}
int timeSinceEpoch() {
  return date.millisecondsSinceEpoch;
}

String formatEnglishDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final day = date.day;

    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    final month = DateFormat('MMMM').format(date);
    final year = date.year;

    return '$day$suffix $month $year';
  }
}