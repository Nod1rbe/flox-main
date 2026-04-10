import 'dart:convert';
import 'dart:html' as html;

void downloadTextFile({
  required String fileName,
  required String content,
}) {
  final encoded = utf8.encode(content);
  final blob = html.Blob([encoded], 'text/csv;charset=utf-8;');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
  anchor.remove();
}
