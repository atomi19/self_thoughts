// display scrollable list of messages

import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(BuildContext, int) onItemTap;

  const MessageList({
    super.key,
    required this.messages, 
    required this.onItemTap,
    });

  @override
  Widget build(BuildContext context) {
    // separate list for messages where 'isPinned' is set to true
    final pinnedMessages = messages.where((message) => message['isPinned'] == true).toList();
    // separate list for messages where we can't find 'isPinned' key, or 'isPinned' key is set to false
    final unpinnedMessages = messages.where((message) => !message.containsKey('isPinned') || message['isPinned'] == false).toList();

    Widget buildSection(String title, List<Map<String, dynamic>> data) {
      return data.isEmpty
        ? const SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 0, 2),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final msg = data[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
                        alignment: Alignment.centerRight,
                        child: Text(msg['date']),
                      ),
                      ListTile(
                        title: Text(msg['message']),
                        onTap: () => onItemTap(context, msg['id']),
                      ),
                    ],
                  ),
                );
              }
            )
          ],
        );
    }

    return messages.isEmpty
      ? const Center(child: Text('No thoughts available', style: TextStyle(fontSize: 25)))
      : SingleChildScrollView(
        child: Column(
          children: [
            buildSection('Pinned', pinnedMessages),
            buildSection('All thoughts', unpinnedMessages),
          ],
        ),
      );
  }
}