// display message input area with TextField and send button

import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const MessageInput({required this.controller, required this.onSend, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          // message input field
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 10,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Type your thoughts',
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
            )
          ),
          SizedBox(width: 5),
          // send button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.grey.shade400)
            ),
            child: IconButton(
              onPressed: () => onSend(controller.text),
              icon: const Icon(Icons.arrow_upward, color: Colors.white)
            )
          )
        ],
      ),
    );
  }
}