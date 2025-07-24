import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/app_extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../calendar/presentation/widgets/event_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.i('🏠 HomeView: Building home screen...');

    // Ensure controller is available
    final homeController = Get.find<HomeController>();
    AppLogger.i('🏠 HomeView: Controller found: ${homeController.runtimeType}');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.agendaCalendar),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.error),
                    SizedBox(width: 8),
                    Text(AppStrings.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        // Try to get AuthController if available, otherwise show basic view
        try {
          final authController = Get.find<AuthController>();
          if (authController.isLoading) {
            return const LoadingWidget(message: AppStrings.loadingUserData);
          }

          final user = authController.currentUser;
          if (user == null) {
            return const Center(child: Text(AppStrings.noUserDataAvailable));
          }

          return _buildHomeContent(context, user);
        } catch (e) {
          // AuthController not available, show fallback
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 64, color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  AppStrings.welcomeToAgenda,
                  style: AppTextStyles.welcomeTitle,
                ),
                SizedBox(height: 8),
                Text(AppStrings.calendarManagementComingSoon),
              ],
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showComingSoonSnackbar(AppStrings.eventCreation);
        },
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newEvent),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Card
          _buildProfileCard(user),

          const SizedBox(height: 24),

          // Quick Actions
          _buildQuickActions(context),

          const SizedBox(height: 24),

          // Calendar Events
          _buildCalendarEvents(),
        ],
      ),
    );
  }

  Widget _buildProfileCard(user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.name?.isNotEmpty == true
                          ? user.name![0].toUpperCase()
                          : user.email[0].toUpperCase(),
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name?.isNotEmpty == true ? user.name! : 'Welcome!',
                    style: AppTextStyles.userNameText,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successWithOpacity10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Authenticated',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.quickActions, style: AppTextStyles.sectionTitle),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_today,
                title: AppStrings.viewCalendar,
                subtitle: 'See all events',
                color: AppColors.primary,
                onTap: () {
                  showComingSoonSnackbar(AppStrings.calendarView);
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildActionCard(
                icon: Icons.add_circle,
                title: AppStrings.createEvent,
                subtitle: 'Quick create',
                color: AppColors.success,
                onTap: () {
                  showComingSoonSnackbar(AppStrings.eventCreation);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.bookmark,
                title: AppStrings.eventTemplates,
                subtitle: 'Event templates',
                color: AppColors.warning,
                onTap: () {
                  showComingSoonSnackbar(AppStrings.eventTemplates);
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildActionCard(
                icon: Icons.settings,
                title: AppStrings.settings,
                subtitle: 'App settings',
                color: AppColors.textSecondary,
                onTap: () {
                  showComingSoonSnackbar(AppStrings.settings);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.cardTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.cardSubtitle.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarEvents() {
    // Try to get CalendarController if available
    try {
      final calendarController = Get.find<CalendarController>();

      return Obx(() {
        if (calendarController.isLoading) {
          return const LoadingWidget(message: 'Loading calendar events...');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Events Section
            if (calendarController.hasTodayEvents) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.todaysEvents,
                    style: AppTextStyles.sectionTitle,
                  ),
                  IconButton(
                    onPressed: () => calendarController.refreshEvents(),
                    icon: calendarController.isRefreshing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...calendarController.todayEvents.map(
                (event) => EventCard(
                  event: event,
                  onTap: () => _showEventDetails(event),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Upcoming Events Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  calendarController.hasTodayEvents
                      ? AppStrings.upcomingEvents
                      : 'Your Events',
                  style: AppTextStyles.sectionTitle,
                ),
                if (!calendarController.hasTodayEvents)
                  IconButton(
                    onPressed: () => calendarController.refreshEvents(),
                    icon: calendarController.isRefreshing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (calendarController.hasUpcomingEvents) ...[
              ...calendarController.upcomingEvents
                  .take(5)
                  .map(
                    (event) => EventCard(
                      event: event,
                      onTap: () => _showEventDetails(event),
                    ),
                  ),

              if (calendarController.upcomingEvents.length > 5) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showComingSoonSnackbar(AppStrings.fullCalendarView);
                    },
                    child: Text(
                      'View All Events (${calendarController.upcomingEvents.length})',
                    ),
                  ),
                ),
              ],
            ] else ...[
              _buildEmptyEventsCard(),
            ],
          ],
        );
      });
    } catch (e) {
      // CalendarController not available, show fallback
      return _buildCalendarUnavailableCard();
    }
  }

  Widget _buildEmptyEventsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.event_available,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.noUpcomingEvents,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your calendar is clear!\nCreate a new event to get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarUnavailableCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.event_busy, size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'Calendar Unavailable',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load calendar events.\nPlease check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(event) {
    AppLogger.i('🎯 HomeView: Navigating to event detail for: ${event.title}');
    Get.toNamed(AppConstants.eventDetailRoute, arguments: event);
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.logoutDialogTitle),
        content: const Text(AppStrings.logoutDialogContent),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Use safe logout method from HomeController
              controller.performLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}
