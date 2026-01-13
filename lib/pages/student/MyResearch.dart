import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class MyResearch extends StatelessWidget {
  const MyResearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Research', style: AppTextStyles.heading3),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getMyResearch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final papers = snapshot.data ?? [];
          if (papers.isEmpty) {
            return Center(child: Text('No submissions yet', style: AppTextStyles.bodyMedium));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final p = papers[index] as Map<String, dynamic>;
              String rawStatus = (p['status'] ?? '').toString();
              String displayStatus = rawStatus.isEmpty ? 'Unknown' : rawStatus.replaceAll('_', ' ').toUpperCase();

              Color chipColor;
              Color textColor = Colors.white;
              if (rawStatus.toLowerCase().contains('approved')) {
                chipColor = AppColors.success;
              } else if (rawStatus.toLowerCase().contains('revision')) {
                chipColor = AppColors.warning;
                textColor = Colors.black;
              } else if (rawStatus.toLowerCase().contains('reject')) {
                chipColor = AppColors.error;
              } else {
                chipColor = AppColors.info;
              }

              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: Text(p['title'] ?? 'Untitled', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(p['abstract'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    rawStatus.toLowerCase().contains('revision') ? 'For Revision' : (rawStatus.isEmpty ? 'Unknown' : (rawStatus.toLowerCase().contains('approved') ? 'Approved' : (rawStatus.toLowerCase().contains('reject') ? 'Rejected' : displayStatus))),
                    style: AppTextStyles.bodyXSmall.copyWith(color: textColor, fontWeight: FontWeight.w600),
                  ),
                ),
                onTap: () {
                  // TODO: Open details view for submission
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: papers.length,
          );
        },
      ),
    );
  }
}
