import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/event_detail_controller.dart';

class EventDetailView extends GetView<EventDetailController> {
  const EventDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.i('📅 EventDetailView: Building event detail screen...');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.eventDetails),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  controller.editEvent();
                  break;
                case 'delete':
                  controller.deleteEvent();
                  break;
                case 'share':
                  controller.shareEvent();
                  break;
                case 'add_to_calendar':
                  controller.addToCalendar();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Edit Event'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: AppColors.info),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'add_to_calendar',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: AppColors.success),
                    SizedBox(width: 8),
                    Text('Add to Device Calendar'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Delete Event'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingWidget(message: 'Loading event details...');
        }

        final event = controller.event;
        if (event == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: AppColors.textHint),
                SizedBox(height: 16),
                Text('Event not found', style: AppTextStyles.heading3),
                SizedBox(height: 8),
                Text(
                  'Unable to load event details',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshEvent(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title Card
                _buildTitleCard(event),

                const SizedBox(height: 16),

                // Event Time Card
                _buildTimeCard(event),

                const SizedBox(height: 16),

                // Event Details Card
                if (event.description?.isNotEmpty == true) ...[
                  _buildDescriptionCard(event),
                  const SizedBox(height: 16),
                ],

                // Event Location Card (if available)
                if (event.location?.isNotEmpty == true) ...[
                  _buildLocationCard(event),
                  const SizedBox(height: 16),
                ],

                // Event Attendees Card (if available)
                if (event.attendeeEmails.isNotEmpty) ...[
                  _buildAttendeesCard(event),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTitleCard(event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getEventColor(event).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getEventIcon(event),
                    color: _getEventColor(event),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: AppTextStyles.heading2),
                      if (event.organizerName?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Organized by ${event.organizerName}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            if (event.isAllDay) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'All Day Event',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Event Time', style: AppTextStyles.cardTitle),
              ],
            ),
            const SizedBox(height: 12),

            if (event.isAllDay) ...[
              _buildTimeRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: _formatDate(event.startTime),
              ),
            ] else ...[
              _buildTimeRow(
                icon: Icons.play_arrow,
                label: 'Start',
                value:
                    '${_formatDate(event.startTime)} at ${_formatTime(event.startTime)}',
              ),
              const SizedBox(height: 8),
              _buildTimeRow(
                icon: Icons.stop,
                label: 'End',
                value:
                    '${_formatDate(event.endTime)} at ${_formatTime(event.endTime)}',
              ),
              const SizedBox(height: 8),
              _buildTimeRow(
                icon: Icons.timelapse,
                label: 'Duration',
                value: _calculateDuration(event.startTime, event.endTime),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
      ],
    );
  }

  Widget _buildDescriptionCard(event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Description', style: AppTextStyles.cardTitle),
              ],
            ),
            const SizedBox(height: 12),
            Text(event.description ?? '', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Location', style: AppTextStyles.cardTitle),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.location ?? '',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Open in maps
                    Get.snackbar(
                      'Coming Soon',
                      'Open in maps will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.map, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeesCard(event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('Attendees', style: AppTextStyles.cardTitle),
                const Spacer(),
                Text(
                  '${event.attendeeEmails.length} people',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...event.attendeeEmails
                .take(5)
                .map(
                  (attendeeEmail) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            attendeeEmail[0].toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            attendeeEmail,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (event.attendeeEmails.length > 5) ...[
              Text(
                'and ${event.attendeeEmails.length - 5} more...',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.editEvent,
                icon: const Icon(Icons.edit),
                label: const Text('Edit Event'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.shareEvent,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.addToCalendar,
            icon: const Icon(Icons.calendar_month),
            label: const Text('Add to Device Calendar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Color _getEventColor(event) {
    // You can customize this based on event type/category
    return AppColors.primary;
  }

  IconData _getEventIcon(event) {
    // You can customize this based on event type/category
    if (event.title.toLowerCase().contains('meeting')) {
      return Icons.business;
    } else if (event.title.toLowerCase().contains('birthday')) {
      return Icons.cake;
    } else if (event.title.toLowerCase().contains('appointment')) {
      return Icons.schedule;
    }
    return Icons.event;
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Today';
    } else if (date == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }
}
