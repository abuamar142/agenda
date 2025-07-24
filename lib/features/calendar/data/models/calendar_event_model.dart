import 'package:googleapis/calendar/v3.dart' as calendar;

import '../../domain/entities/calendar_event.dart';

class CalendarEventModel extends CalendarEvent {
  const CalendarEventModel({
    required super.id,
    required super.title,
    super.description,
    required super.startTime,
    required super.endTime,
    super.location,
    super.isAllDay,
    super.organizerEmail,
    super.organizerName,
    super.attendeeEmails,
    super.status,
    super.meetingLink,
    super.calendarId,
  });

  factory CalendarEventModel.fromGoogleEvent(calendar.Event event) {
    // Parse start time
    DateTime startTime;
    DateTime endTime;
    bool isAllDay = false;

    if (event.start?.date != null) {
      // All-day event
      startTime = event.start!.date!;
      endTime = event.end?.date ?? startTime.add(const Duration(days: 1));
      isAllDay = true;
    } else if (event.start?.dateTime != null) {
      // Timed event
      startTime = event.start!.dateTime!;
      endTime = event.end?.dateTime ?? startTime.add(const Duration(hours: 1));
      isAllDay = false;
    } else {
      // Fallback
      startTime = DateTime.now();
      endTime = startTime.add(const Duration(hours: 1));
    }

    // Extract attendee emails
    final attendeeEmails =
        event.attendees
            ?.map((attendee) => attendee.email ?? '')
            .where((email) => email.isNotEmpty)
            .toList() ??
        <String>[];

    // Extract meeting link from various sources
    String? meetingLink;
    if (event.hangoutLink?.isNotEmpty == true) {
      meetingLink = event.hangoutLink;
    } else if (event.conferenceData?.entryPoints?.isNotEmpty == true) {
      meetingLink = event.conferenceData!.entryPoints!
          .firstWhere(
            (entry) => entry.uri?.isNotEmpty == true,
            orElse: () => calendar.EntryPoint(),
          )
          .uri;
    }

    return CalendarEventModel(
      id: event.id ?? '',
      title: event.summary ?? 'No Title',
      description: event.description,
      startTime: startTime,
      endTime: endTime,
      location: event.location,
      isAllDay: isAllDay,
      organizerEmail: event.organizer?.email,
      organizerName: event.organizer?.displayName,
      attendeeEmails: attendeeEmails,
      status: event.status ?? 'confirmed',
      meetingLink: meetingLink,
      calendarId: event.iCalUID,
    );
  }

  calendar.Event toGoogleEvent() {
    final event = calendar.Event();

    event.id = id;
    event.summary = title;
    event.description = description;
    event.location = location;
    event.status = status;

    if (isAllDay) {
      event.start = calendar.EventDateTime()
        ..date = DateTime(startTime.year, startTime.month, startTime.day);
      event.end = calendar.EventDateTime()
        ..date = DateTime(endTime.year, endTime.month, endTime.day);
    } else {
      event.start = calendar.EventDateTime()..dateTime = startTime;
      event.end = calendar.EventDateTime()..dateTime = endTime;
    }

    if (attendeeEmails.isNotEmpty) {
      event.attendees = attendeeEmails
          .map((email) => calendar.EventAttendee()..email = email)
          .toList();
    }

    if (meetingLink?.isNotEmpty == true) {
      event.hangoutLink = meetingLink;
    }

    return event;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'isAllDay': isAllDay,
      'organizerEmail': organizerEmail,
      'organizerName': organizerName,
      'attendeeEmails': attendeeEmails,
      'status': status,
      'meetingLink': meetingLink,
      'calendarId': calendarId,
    };
  }

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      isAllDay: json['isAllDay'] ?? false,
      organizerEmail: json['organizerEmail'],
      organizerName: json['organizerName'],
      attendeeEmails: List<String>.from(json['attendeeEmails'] ?? []),
      status: json['status'] ?? 'confirmed',
      meetingLink: json['meetingLink'],
      calendarId: json['calendarId'],
    );
  }
}
