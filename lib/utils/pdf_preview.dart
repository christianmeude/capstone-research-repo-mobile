// Conditional import wrapper for PDF preview helpers
import 'dart:typed_data';
import 'pdf_preview_io.dart'
    if (dart.library.html) 'pdf_preview_web.dart' as impl;

Future<void> previewPdfBytes(Uint8List bytes, String filename) => impl.previewPdfBytes(bytes, filename);
Future<void> previewPdfPath(String path) => impl.previewPdfPath(path);
