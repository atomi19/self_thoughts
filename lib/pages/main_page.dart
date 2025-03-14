import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // contoller for the message input field
  final TextEditingController _messageController = TextEditingController();

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
          "id": _messages.length + 1,
          "message": message,
          "date": time
        });
      });
      
      // save list to shared_preferences
      _saveMessages();
    }
  }

  // remove message from the list by its id
  void _removeMessage(int id) {
    setState(() {
      _messages.removeWhere((message) => message['id'] == id);
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
                return Dismissible(
                  key: ValueKey(_messages[index]['id']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(10),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    final messageId = _messages[index]['id'];

                    _removeMessage(messageId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thought has been removed'))
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Text(_messages[index]["message"]),
                      trailing: Text(_messages[index]["date"]),
                    ),
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
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your thoughts',
                      border: InputBorder.none
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