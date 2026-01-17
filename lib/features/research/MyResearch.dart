import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/services/api_service.dart';

class MyResearch extends StatelessWidget {
  const MyResearch({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getMyResearch(), // Fetch real papers
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final papers = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Submissions", style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text("Track the status of your papers", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              
              const SizedBox(height: 24),
              
              if (papers.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text("No submissions yet.", style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: papers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final paper = papers[index];
                    final status = paper['status'] ?? 'pending'; // Default to pending
                    
                    // Determine color based on status
                    Color statusColor = AppColors.warning; // Default Yellow (Pending)
                    IconData statusIcon = Icons.access_time;
                    
                    if (status == 'approved' || status == 'published') {
                      statusColor = AppColors.success;
                      statusIcon = Icons.check_circle;
                    } else if (status == 'rejected') {
                      statusColor = AppColors.error;
                      statusIcon = Icons.cancel;
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50, width: 50,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(statusIcon, color: statusColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  paper['title'] ?? 'Untitled',
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Status: ${status.toString().toUpperCase()}",
                                  style: AppTextStyles.bodyXSmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
            ],
          ),
        );
      },
    );
  }
}