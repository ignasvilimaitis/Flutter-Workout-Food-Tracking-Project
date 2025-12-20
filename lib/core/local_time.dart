import 'package:intl/intl.dart';

class LocalTime {
DateTime date = DateTime.now();
String get today => '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';
String get militaryTimeH => '${date.hour}';
String get militaryTimeM => '${date.minute}';
String get dbDate => DateFormat('yyyy-MM-dd').format(date);

String getPreviousDate(String currentDate) {
  DateTime parsedDate = DateTime.parse(currentDate);
  DateTime previousDate = parsedDate.subtract(Duration(days: 1));
  return DateFormat('yyyy-MM-dd').format(previousDate);

}

String getAheadDate(String currentDate) {
  DateTime parsedDate = DateTime.parse(currentDate);
  DateTime previousDate = parsedDate.add(Duration(days: 1));
  return DateFormat('yyyy-MM-dd').format(previousDate);

}
double timeSinceEpoch() {
  return date.millisecondsSinceEpoch.toDouble();
}
}