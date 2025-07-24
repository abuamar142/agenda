import 'package:equatable/equatable.dart';

class EventTemplate extends Equatable {
  final String id;
  final String name;
  final String title;
  final String? description;
  final int durationMinutes;
  final String? location;
  final bool isAllDay;
  final List<String> defaultAttendees;
  final String? category;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventTemplate({
    required this.id,
    required this.name,
    required this.title,
    this.description,
    required this.durationMinutes,
    this.location,
    this.isAllDay = false,
    this.defaultAttendees = const [],
    this.category,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    title,
    description,
    durationMinutes,
    location,
    isAllDay,
    defaultAttendees,
    category,
    color,
    createdAt,
    updatedAt,
  ];

  EventTemplate copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    int? durationMinutes,
    String? location,
    bool? isAllDay,
    List<String>? defaultAttendees,
    String? category,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      defaultAttendees: defaultAttendees ?? this.defaultAttendees,
      category: category ?? this.category,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => Duration(minutes: durationMinutes);
}
