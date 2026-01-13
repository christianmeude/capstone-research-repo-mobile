import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/stat_card.dart';
import 'SubmitResearch.dart';
import 'MyResearch.dart';
import 'BrowseRepository.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // Logo placeholder - add your actual logo asset
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ResearchHub',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'NU Communities',
                  style: AppTextStyles.bodyXSmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header - from your screenshot
            DashboardHeader(
              name: 'Malfoy De Vera',
              role: 'Research Scholar',
              institution: 'National University Dasmarifias',
              date: 'Tuesday, January 6, 2026',
              avatarColor: AppColors.primary500,
            ),

            const SizedBox(height: 32),

            // Research Actions Section - from your screenshot
            Text(
              'Research Actions',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Manage your academic contributions',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            // Quick Action Grid - exactly like your screenshot
            // In StudentDashboard.dart, replace the GridView with this:
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio:
                  0.85, // CHANGED from 1.2 to 0.85 for better proportions
              children: [
                QuickActionCard(
                  icon: Icons.upload_file,
                  title: 'Submit Research',
                  subtitle: 'Upload new academic paper',
                  color: AppColors.primary500,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SubmitResearch()),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.library_books,
                  title: 'My Research',
                  subtitle: 'View all submissions',
                  color: AppColors.success,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyResearch()),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.search,
                  title: 'Browse Repository',
                  subtitle: 'Explore academic papers',
                  color: AppColors.info,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BrowseRepository()),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Account preferences',
                  color: AppColors.warning,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),

            // Recent Submissions Section - from your screenshot
            Text(
              'Recent Submissions',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Latest research activity',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            // Stats Cards for recent submissions
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Pending',
                    value: '2',
                    color: AppColors.warning,
                    icon: Icons.access_time,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'In Review',
                    value: '1',
                    color: AppColors.info,
                    icon: Icons.visibility,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Recent submissions list
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.note, color: AppColors.primary500),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'helllo',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Submitted 2 days ago',
                              style: AppTextStyles.bodyXSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Pending',
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.borderLight, height: 1),
                  const SizedBox(height: 12),
                  Text(
                    'No other recent submissions',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                      fontStyle: FontStyle.italic,
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
}
