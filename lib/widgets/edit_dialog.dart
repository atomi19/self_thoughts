// display modal bottom sheet for editing message

import 'package:flutter/material.dart';
import 'package:self_thoughts/message_service.dart';

void showEditDialog(BuildContext context, 
                    int messageId, 
                    TextEditingController editMessageController, 
                    List<Map<String, dynamic>> messages, 
                    Function(int, String) editMessage
                    ) {
  final int index = MessageService.findIndexOfMessage(messages, messageId);
  editMessageController.text = messages[index]['message'];

  showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 10, 
          right: 20, 
          top: 15, 
          bottom: MediaQuery.of(context).viewInsets.bottom + 15
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: editMessageController,
                decoration: InputDecoration(
                  labelText: 'Edit',
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  border: OutlineInputBorder()
                ),
                minLines: 1,
                maxLines: 10,
              )
            ),
            SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                border: Border.all(color: Colors.grey.shade400)
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  editMessage(messageId, editMessageController.text);
                },
                icon: const Icon(Icons.arrow_upward, color: Colors.white)
              )
            )
          ],
        ),
      );
    }
  );  
}