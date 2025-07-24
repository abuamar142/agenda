import 'package:intl/intl.dart';

class DateTimeUtils {
  // Date formatters
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _displayTimeFormat = DateFormat('HH:mm');
  static final DateFormat _displayDateTimeFormat = DateFormat(
    'dd MMM yyyy, HH:mm',
  );

  // Format date to string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  // Format time to string
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  // Format datetime to string
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  // Format date for display
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  // Format time for display
  static String formatDisplayTime(DateTime time) {
    return _displayTimeFormat.format(time);
  }

  // Format datetime for display
  static String formatDisplayDateTime(DateTime dateTime) {
    return _displayDateTimeFormat.format(dateTime);
  }

  // Parse date from string
  static DateTime? parseDate(String date) {
    try {
      return _dateFormat.parse(date);
    } catch (e) {
      return null;
    }
  }

  // Parse datetime from string
  static DateTime? parseDateTime(String dateTime) {
    try {
      return _dateTimeFormat.parse(dateTime);
    } catch (e) {
      return null;
    }
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Get relative date string
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDisplayDate(date);
    }
  }

  // Get days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // Get week start (Monday)
  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Get week end (Sunday)
  static DateTime getWeekEnd(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  // Get month start
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get month end
  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
}
