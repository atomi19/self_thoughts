import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

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
    // load messages from shared_preferences when app starts
    _loadMessages();
  }

  // add new message to list 
  void _addMessage() {
    String message = _messageController.text;
    String time = _getTime();

    if(message.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "id": _generateId(),
          "message": message,
          "date": time
        });
      });
      
      // save list to shared_preferences
      _saveMessages();
    }
  }

  // remove message from the list by its id
  void _removeMessage(int messageId) {
    setState(() {
      _messages.removeWhere((message) => message['id'] == messageId);
    });

    _saveMessages();
  }

  // get time when message were made, like 09:59
  String _getTime() {
    DateTime date = DateTime.now();

    String time = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return time;
  }

  // save messages to shared_preferences
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String messagesJson = json.encode(_messages);
    await prefs.setString('messages', messagesJson);
  }

  // load messages from shared_preferences 
  Future<List<Map<String, dynamic>>> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();

    String? messagesJson = prefs.getString('messages') ?? '[]';

    List<dynamic> decodedList = json.decode(messagesJson);

    setState(() {
      _messages = decodedList.cast<Map<String, dynamic>>().toList();
    });

    return decodedList.cast<Map<String, dynamic>>().toList();
  }

  // generate unique id for message
  int _generateId() {
    int messageId;
    do {
      messageId = Random().nextInt(1000000);
    } while (_messages.any((message) => message['id'] == messageId)); // check if id exists
    return messageId;
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
                  _editMessage(messageId);
                },
              )
            ],
          ),
        );
      }
    );
  }

  // show edit message menu
  void _editMessage(int messageIdToEdit) {
    // get index of message
    int index = _messages.indexWhere((message) => message['id'] == messageIdToEdit);

    // insert old message into edit text field
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
                  setState(() {
                    _messages[index]['message'] = _editMessageController.text;
                    _saveMessages();
                  });
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
                  onPressed: () {
                    _addMessage();
                    _messageController.clear();
                  },
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