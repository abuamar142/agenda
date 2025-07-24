import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isAllDay;
  final String? organizerEmail;
  final String? organizerName;
  final List<String> attendeeEmails;
  final String status; // confirmed, tentative, cancelled
  final String? meetingLink;
  final String? calendarId;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isAllDay = false,
    this.organizerEmail,
    this.organizerName,
    this.attendeeEmails = const [],
    this.status = 'confirmed',
    this.meetingLink,
    this.calendarId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startTime,
    endTime,
    location,
    isAllDay,
    organizerEmail,
    organizerName,
    attendeeEmails,
    status,
    meetingLink,
    calendarId,
  ];

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(startTime.year, startTime.month, startTime.day);
    return eventDate.isAtSameMomentAs(today);
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  Duration get duration {
    return endTime.difference(startTime);
  }

  String get formattedTimeRange {
    if (isAllDay) {
      return 'All day';
    }

    final startTimeStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    return '$startTimeStr - $endTimeStr';
  }

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? isAllDay,
    String? organizerEmail,
    String? organizerName,
    List<String>? attendeeEmails,
    String? status,
    String? meetingLink,
    String? calendarId,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      organizerEmail: organizerEmail ?? this.organizerEmail,
      organizerName: organizerName ?? this.organizerName,
      attendeeEmails: attendeeEmails ?? this.attendeeEmails,
      status: status ?? this.status,
      meetingLink: meetingLink ?? this.meetingLink,
      calendarId: calendarId ?? this.calendarId,
    );
  }
}
