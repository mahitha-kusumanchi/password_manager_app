import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LogAction {
  final String action;
  final DateTime timestamp;

  LogAction({required this.action, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'action': action,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LogAction.fromJson(Map<String, dynamic> json) => LogAction(
        action: json['action'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class LogService {
  static const String _storageKey = 'user_action_logs';

  Future<List<LogAction>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getStringList(_storageKey) ?? [];
    
    return logsJson
        .map((e) => LogAction.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
  }

  Future<void> logAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getLogs();
    
    final newLog = LogAction(
      action: action,
      timestamp: DateTime.now(),
    );

    // Keep only last 100 logs to prevent infinite growth
    if (logs.length >= 100) {
      logs.removeLast();
    }
    
    // Insert new log at the beginning (though we sort on retrieval anyway)
    logs.insert(0, newLog);

    final logsJson = logs.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, logsJson);
  }

  Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
