import 'package:intl/intl.dart';

String formatGMTplus3(String utcDateString) {
  final utcDate = DateTime.parse(utcDateString).toUtc();
  final utcPlus3Date = utcDate.add(const Duration(hours: 3));
  // return DateFormat('yyyy-MM-dd HH:mm').format(utcPlus3Date);
  return DateFormat('HH:mm').format(utcPlus3Date);
}

String formatDate(String date) {
  return date.split('T')[0].split('-').reversed.join('/');
}
