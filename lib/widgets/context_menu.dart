// display context menu when a message(ListTile) is tapped

import 'package:flutter/material.dart';

void showContextMenu(
  BuildContext context, 
  int messageId, 
  List<Map<String, dynamic>> messages, 
  Function(int) removeMessage, 
  Function(int) copyToClipboard, 
  Function(BuildContext, int) showEditDialog
  ) {
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
              leading: const Icon(Icons.delete_outlined, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                removeMessage(messageId);
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
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                copyToClipboard(messageId);
              },
            )
          ],
        ),
      );
    }
  );
}