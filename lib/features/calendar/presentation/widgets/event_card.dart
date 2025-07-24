import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../domain/entities/calendar_event.dart';

class EventCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getEventColor(), width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: AppTextStyles.eventTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(),
                ],
              ),

              const SizedBox(height: 8),

              _buildTimeRow(),

              if (event.location?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                _buildLocationRow(),
              ],

              if (event.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  style: AppTextStyles.eventDescription.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (event.attendeeEmails.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildAttendeesRow(),
              ],

              if (event.meetingLink?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                _buildMeetingLinkRow(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Icon(
          event.isAllDay ? Icons.calendar_today : Icons.access_time,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _getTimeText(),
            style: AppTextStyles.eventTime.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            event.location!,
            style: AppTextStyles.eventLocation.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeesRow() {
    return Row(
      children: [
        const Icon(Icons.people, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${event.attendeeEmails.length} attendee${event.attendeeEmails.length != 1 ? 's' : ''}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingLinkRow() {
    return Row(
      children: [
        const Icon(Icons.video_call, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'Meeting link available',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    if (event.isOngoing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'ONGOING',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
        ),
      );
    } else if (event.isUpcoming && event.isToday) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'TODAY',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getEventColor() {
    if (event.isOngoing) {
      return AppColors.success;
    } else if (event.isToday) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }

  String _getTimeText() {
    if (event.isAllDay) {
      if (event.startTime.day == event.endTime.day) {
        return 'All day • ${DateFormat('MMM d').format(event.startTime)}';
      } else {
        return 'All day • ${DateFormat('MMM d').format(event.startTime)} - ${DateFormat('MMM d').format(event.endTime)}';
      }
    } else {
      final dateFormat = DateFormat('MMM d');
      final timeFormat = DateFormat('HH:mm');

      if (event.startTime.day == event.endTime.day) {
        return '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)} • ${dateFormat.format(event.startTime)}';
      } else {
        return '${dateFormat.format(event.startTime)} ${timeFormat.format(event.startTime)} - ${dateFormat.format(event.endTime)} ${timeFormat.format(event.endTime)}';
      }
    }
  }
}
