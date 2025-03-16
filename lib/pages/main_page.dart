import 'package:flutter/material.dart';
import 'package:self_thoughts/message_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // contoller for the message input field
  final TextEditingController _messageController = TextEditingController();
  // controller for the edit input field
  final TextEditingController _editMessageController = TextEditingController();
  // list to store messages as a map with id, message and time when they were made
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // add new message to list 
  void _addMessage(String message) {
    if(message.trim().isNotEmpty) {
      setState(() {
        _messages.add(MessageService.createMessage(message));
      });
      MessageService.saveMessages(_messages);
      _messageController.clear();
    }
  }

  // remove message from the list by its id
  void _removeMessage(int messageId) {
    setState(() {
      _messages.removeWhere((message) => message['id'] == messageId);
    });
    MessageService.saveMessages(_messages);
  }

  void _editMessage(int messageId, String newMessage) {
    setState(() {
      final int index = _messages.indexWhere((message) => message['id'] == messageId);
      if(index != -1) {
        _messages[index]['message'] = newMessage;
      }
    });
    MessageService.saveMessages(_messages);
  }

  // load messages from shared_preferences 
  Future<void> _loadMessages() async {
    final loadedMessages = await MessageService.loadMessages();
    setState(() {
      _messages = loadedMessages;
    });
  }

  // show context menu on ListTile click
  void _showContextMenu(BuildContext context, int messageId) {
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
                  _removeMessage(messageId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  //_editMessage(messageId, _messageController.text);
                  _showEditDialog(context, messageId);
                },
              )
            ],
          ),
        );
      }
    );
  }

  void _showEditDialog(BuildContext context, int messageId) {
    final index = _messages.indexWhere((message) => message['id'] == messageId);
    _editMessageController.text = _messages[index]['message'];

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
            top: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 15
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _editMessageController,
                  decoration: InputDecoration(labelText: 'Edit'),
                  minLines: 1,
                  maxLines: 10,
                )
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editMessage(messageId, _editMessageController.text);
                }, 
                icon: const Icon(Icons.send)
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // display ListTile with messages or placeholder if there is no messages
          Expanded(
            child: _messages.isEmpty
            ? const Center(child: Text('No thoughts available', style: TextStyle(fontSize: 25)))
            : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                    title: Text(_messages[index]["message"]),
                    trailing: Text(_messages[index]["date"]),
                    onTap: () => _showContextMenu(context, _messages[index]['id']),
                  ),
                );
              }
            )
          ),
          // input field for adding messages
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 8,
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your thoughts',
                      border: InputBorder.none,
                    ),
                  )
                ),
                // send button to add messages
                IconButton(
                  onPressed: () => _addMessage(_messageController.text),
                  icon: const Icon(Icons.send)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}