// Web implementation: opens the PDF bytes or URL in a new browser tab
import 'dart:typed_data';
import 'dart:html' as html;

Future<void> previewPdfBytes(Uint8List bytes, String filename) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
}

Future<void> previewPdfPath(String path) async {
  html.window.open(path, '_blank');
}
