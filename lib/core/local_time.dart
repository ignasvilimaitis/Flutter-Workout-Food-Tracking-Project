import 'package:intl/intl.dart';

class LocalTime {
DateTime date = DateTime.now();
String get today => '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';
String get militaryTimeH => '${date.hour}';
String get militaryTimeM => '${date.minute}';

}