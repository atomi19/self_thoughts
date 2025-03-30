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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            ),
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 10, 2),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(messages[index]['date']),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(messages[index]['message']),
                  onTap: () => onItemTap(context, messages[index]['id']),
                )
              ],
            ),
          );
        }
      );
  }
}