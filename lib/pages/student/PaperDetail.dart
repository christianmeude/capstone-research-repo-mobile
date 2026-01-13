import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/pdf_preview.dart';

class PaperDetail extends StatelessWidget {
  final Map<String, dynamic> paper;
  const PaperDetail({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
    final title = paper['title'] ?? 'Untitled';
    final abstract = paper['abstract'] ?? '';
    final fileUrl = paper['fileUrl'] ?? paper['file_url'] ?? paper['url'] ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: AppTextStyles.heading4),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          bottom: TabBar(
            labelColor: AppColors.primary600,
            tabs: const [Tab(text: 'Overview'), Tab(text: 'AI Assistant')],
          ),
        ),
        body: TabBarView(
          children: [
            // Overview
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Abstract', style: AppTextStyles.heading4),
                  const SizedBox(height: 8),
                  Text(abstract, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: fileUrl.isEmpty ? null : () async {
                      // Open fileUrl in preview; on web this opens a new tab, on mobile tries to open system viewer
                      if (kIsWeb) {
                        await previewPdfPath(fileUrl);
                      } else {
                        await previewPdfPath(fileUrl);
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('View PDF'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500),
                  ),
                ],
              ),
            ),

            // AI Assistant (placeholder)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('AI Assistant coming soon — chat or summarize this paper.', style: AppTextStyles.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
