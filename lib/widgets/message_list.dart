// display scrollable list of messages

import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(BuildContext, int) onItemTap;

  const MessageList({
    super.key,
    required this.messages, 
    required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    // separate list for messages where 'isPinned' is set to true
    final pinnedMessages = messages.where((message) => message['isPinned'] == true).toList();
    // separate list for messages where we can't find 'isPinned' key, or 'isPinned' key is set to false
    final unpinnedMessages = messages.where((message) => !message.containsKey('isPinned') || message['isPinned'] == false).toList();

    return messages.isEmpty
    ? const Center(child: Text('No thoughts available', style: TextStyle(fontSize: 25)))
    : SingleChildScrollView(
      child: Column(
        children: [
        // pinned messages
        if(pinnedMessages.isNotEmpty) 
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text('Pinned', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ),
        ListView.builder(
          itemCount: pinnedMessages.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                        child: Text(pinnedMessages[index]['date']),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(pinnedMessages[index]['message']),
                    onTap: () => onItemTap(context, pinnedMessages[index]['id']),
                  )
                ],
              ),
            );
          }
        ),
        // unpinned messages
        if(unpinnedMessages.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: const Text('All thoughts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: unpinnedMessages.length,
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
                          child: Text(unpinnedMessages[index]['date']),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(unpinnedMessages[index]['message']),
                      onTap: () => onItemTap(context, unpinnedMessages[index]['id']),
                    )
                  ],
                ),
              );
            }
          )
        ],
      )
    );
  }
}