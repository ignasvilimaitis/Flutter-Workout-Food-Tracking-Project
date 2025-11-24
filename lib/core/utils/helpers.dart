import 'dart:convert';
import 'package:flutter/services.dart';

// Helper function to read JSON file from assets
Future<dynamic> readJson(final String path) async {
  final String resp = await rootBundle.loadString(path);
  return await jsonDecode(resp);
}