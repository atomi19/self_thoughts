// display scrollable list of messages

import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(BuildContext, int) onItemTap;

  const MessageList({required this.messages, required this.onItemTap, super.key});

  @override
  Widget build(BuildContext context) {
    return messages.isEmpty
    ? const Center(child: Text('No thoughts available', style: TextStyle(fontSize: 25)))
    : ListView.builder(
      itemCount: messages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              title: Text(messages[index]['message']!),
              trailing: Text(messages[index]['date']!),
              onTap: () => onItemTap(context, messages[index]['id']!),
            ),
          );
        }
      );
  }
}