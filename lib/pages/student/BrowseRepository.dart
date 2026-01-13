import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'PaperDetail.dart';

class BrowseRepository extends StatelessWidget {
  const BrowseRepository({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Repository', style: AppTextStyles.heading3),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getPublishedPapers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final papers = snapshot.data ?? [];
          if (papers.isEmpty) return Center(child: Text('No published papers found', style: AppTextStyles.bodyMedium));

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: papers.length,
            itemBuilder: (context, index) {
              final p = papers[index] as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaperDetail(paper: p)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primary500.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(Icons.picture_as_pdf, color: AppColors.primary500, size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(p['title'] ?? 'Untitled', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(p['abstract'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
