// display context menu when a message(ListTile) is tapped

import 'package:flutter/material.dart';
import 'package:self_thoughts/message_service.dart';

void showContextMenu({
  required BuildContext context, 
  required int messageId, 
  required List<Map<String, dynamic>> messages, 
  required Function(int) removeMessage, 
  required Function(int) copyToClipboard, 
  required Function(BuildContext, int) showEditDialog,
  required Function(int) pinMessage
  }) {
  final message = messages[MessageService.findIndexOfMessage(messages, messageId)];
  
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                copyToClipboard(messageId);
              },
            ),
            ListTile(
              // if message doesn't have the 'isPinned' key or it's false, show pin icon
              // otherwise show unpin(cancel) icon
              leading: Icon(
                (!message.containsKey('isPinned') || message['isPinned'] == false)
                ? Icons.push_pin_outlined
                : Icons.cancel_outlined
              ),
              // if message doesn't have the 'isPinned' key or it's false, show 'Pin'
              // otherwise show 'Unpin'
              title: Text(
                (!message.containsKey('isPinned') || message['isPinned'] == false)
                ? 'Pin'
                : 'Unpin'
              ),
              onTap: () {
                Navigator.pop(context);
                pinMessage(messageId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                showEditDialog(context, messageId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outlined, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                removeMessage(messageId);
              },
            ),
          ],
        ),
      );
    }
  );
}