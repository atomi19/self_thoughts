import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class MessageService {
  static Map<String, dynamic> createMessage(String message) {
    return {
      'id': _generateId(),
      'message': message,
      'date': _getTime()
    };
  }

  // save messages to shared_preferences
  static Future<void> saveMessages(List<Map<String,dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = json.encode(messages);
    await prefs.setString('messages', messagesJson);
  }
  
  // load messages from shared_preferences
  static Future<List<Map<String, dynamic>>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages') ?? '[]';
    final List<dynamic> decodedList = json.decode(messagesJson);
    return decodedList.cast<Map<String, dynamic>>().toList();
  }

  // get time when message were made, like 09:59
  static String _getTime() {
    final DateTime date = DateTime.now();
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // generate unique id for message
  static int _generateId() {
    return Random().nextInt(1000000);
  }
}