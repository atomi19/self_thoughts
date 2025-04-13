import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class MessageService {
  static Map<String, dynamic> createMessage(String message) {
    return {
      'id': generateId(),
      'message': message,
      'date': getTime(),
      'isPinned': false,
    };
  }

  // save messages to shared_preferences
  static Future<void> saveMessages(List<Map<String,dynamic>> messages, String keyName) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = json.encode(messages);
    await prefs.setString(keyName, messagesJson);
  }
  
  // load messages from shared_preferences
  static Future<List<Map<String, dynamic>>> loadMessages(String keyName) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(keyName) ?? '[]';
    final List<dynamic> decodedList = json.decode(messagesJson);
    return decodedList.cast<Map<String, dynamic>>().toList();
  }

  // move message from _messages to _trash
  static void addMessageToTrash({
    required List<Map<String, dynamic>> messages, 
    required List<Map<String, dynamic>> trash, 
    required int messageId,
  }) {
    final msg = messages.firstWhere((m) => m['id'] == messageId);
    trash.add(msg);
  }

  // delete message from trash forever
  static void deleteMessageForever({
    required List<Map<String, dynamic>> trash,
    required int messageId,
  }) {
    trash.removeWhere((m) => m['id'] == messageId);
  }

  // recover message from trash
  static void recoverMessageFromTrash({
    required List<Map<String, dynamic>> trash,
    required List<Map<String, dynamic>> messages,
    required int messageId,
  }) {
    final msg = trash.firstWhere((m) => m['id'] == messageId);
    messages.add(msg);
    trash.removeWhere((m) => m['id'] == messageId);
  }

  // clear trash 
  static void clearTrash(List<Map<String, dynamic>> trash) {
    trash.clear();
  }

  // copy message to clipboard
  static void copyToClipboard(List<Map<String, dynamic>> messages, int messageId) {
    final int index = findIndexOfMessage(messages, messageId);
    Clipboard.setData(ClipboardData(text: messages[index]['message']));
  }

  // pin or unpin message(set 'isPinned' key to false or true)
  static void togglePin(List<Map<String, dynamic>> messages, int messageId) {
    final int index = findIndexOfMessage(messages, messageId);
    messages[index]['isPinned'] = !messages[index]['isPinned'];
  }

  // get time when message were made (dd.mm.yyyy hh:mm)
  static String getTime() {
    final DateTime date = DateTime.now();
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year.toString()} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // generate unique id for message
  static int generateId() {
    return Random().nextInt(1000000);
  }
  
  // find index of message
  static int findIndexOfMessage(List<Map<String,dynamic>> messages, int messageId) {
    return messages.indexWhere((message) => message['id'] == messageId);
  }
}