import 'package:flutter/material.dart';
import 'package:self_thoughts/message_service.dart';
import 'package:flutter/services.dart';
import 'package:self_thoughts/widgets/context_menu.dart';
import 'package:self_thoughts/widgets/message_list.dart';
import 'package:self_thoughts/widgets/message_input.dart';
import 'package:self_thoughts/widgets/edit_dialog.dart';
import 'package:self_thoughts/widgets/custom_app_bar.dart';
import 'package:self_thoughts/widgets/trash_context_menu.dart';

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
  List<Map<String, dynamic>> _trash = [];
  static const String messagesKey = 'messages';
  static const String trashKey = 'trash';

  @override
  void initState() {
    super.initState();
    _loadMessages(messagesKey);
    _loadMessages(trashKey);
  }

  // add new message to list 
  void _addMessage(String message) {
    if(message.trim().isNotEmpty) {
      setState(() {
        _messages.add(MessageService.createMessage(message));
      });
      MessageService.saveMessages(_messages, messagesKey);
      _messageController.clear();
    }
  }

  // remove message from the list by its id
  void _removeMessage(int messageId) {
    _addMessageToTrash(messageId);
    setState(() {
      _messages.removeWhere((message) => message['id'] == messageId);
    });
    MessageService.saveMessages(_messages, messagesKey);
  }

  void _editMessage(int messageId, String newMessage) {
    setState(() {
      final int index = MessageService.findIndexOfMessage(_messages, messageId);
      if(index != -1) {
        _messages[index]['message'] = newMessage;
      }
    });
    MessageService.saveMessages(_messages, messagesKey);
  }

  // load messages from shared_preferences 
  Future<void> _loadMessages(String keyName) async {
    final loadedMessages = await MessageService.loadMessages(keyName);
    setState(() {
      if(keyName == messagesKey) {
        _messages = loadedMessages;
      } else if(keyName == trashKey) {
        _trash = loadedMessages;
      }
    });
  }

  void _copyToClipboard(int messageId) {
    final int index = MessageService.findIndexOfMessage(_messages, messageId);
    Clipboard.setData(ClipboardData(text: _messages[index]['message']));
  }

  void _addMessageToTrash(int messageId) {
    _trash.add(_messages.firstWhere((message) => message['id'] == messageId));
    MessageService.saveMessages(_trash, trashKey);
  }

  void _deleteMessageForever(int messageId) {
    final int index = MessageService.findIndexOfMessage(_trash, messageId);
    _trash.removeAt(index);
    MessageService.saveMessages(_trash, trashKey);
  }

  void _recoverMessageFromTrash(int messageId) {
    final int index = MessageService.findIndexOfMessage(_trash, messageId);
    _messages.add(_trash[index]);
    _trash.removeAt(index);
    MessageService.saveMessages(_messages, messagesKey);
    MessageService.saveMessages(_trash, trashKey);
  }

  void _deleteAllMessagesInTrash() {
    _trash.clear();
    MessageService.saveMessages(_trash, trashKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        trashCount: _trash.length, 
        onTrashSelected: () {
          showTrashDialog(
            context, 
            _trash.length, 
            _trash, 
            _deleteMessageForever, 
            _recoverMessageFromTrash, 
            _deleteAllMessagesInTrash,
            setState
          );
        }
      ),
      body: Column(
        children: [
          // display ListTile with messages or placeholder if there is no messages
          Expanded(child: MessageList(messages: _messages, onItemTap: (context, messageId) {
            showContextMenu(context, messageId, _messages, _removeMessage, _copyToClipboard, (context, messageId) {
              showEditDialog(context, messageId, _editMessageController, _messages, _editMessage);
            });
          })),
          // input field for adding messages
          MessageInput(controller: _messageController, onSend: _addMessage)
        ],
      ),
    );
  }
}