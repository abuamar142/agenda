import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isAllDay;
  final String? calendarId;
  final List<String> attendees;
  final String? recurrence;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isAllDay = false,
    this.calendarId,
    this.attendees = const [],
    this.recurrence,
    required this.createdAt,
    required this.updatedAt,
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
    calendarId,
    attendees,
    recurrence,
    createdAt,
    updatedAt,
  ];

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? isAllDay,
    String? calendarId,
    List<String>? attendees,
    String? recurrence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      calendarId: calendarId ?? this.calendarId,
      attendees: attendees ?? this.attendees,
      recurrence: recurrence ?? this.recurrence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => endTime.difference(startTime);

  bool get isToday {
    final now = DateTime.now();
    final startDate = DateTime(startTime.year, startTime.month, startTime.day);
    final today = DateTime(now.year, now.month, now.day);
    return startDate == today;
  }

  bool get isPast => endTime.isBefore(DateTime.now());

  bool get isUpcoming => startTime.isAfter(DateTime.now());
}
