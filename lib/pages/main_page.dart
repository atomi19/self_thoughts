import 'package:flutter/material.dart';
import 'package:self_thoughts/message_service.dart';
// pages
import 'package:self_thoughts/pages/trash_page.dart';
import 'package:self_thoughts/pages/search_page.dart';
// widgets
import 'package:self_thoughts/widgets/context_menu.dart';
import 'package:self_thoughts/widgets/message_list.dart';
import 'package:self_thoughts/widgets/message_input.dart';
import 'package:self_thoughts/widgets/edit_dialog.dart';
import 'package:self_thoughts/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _editMessageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

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

  // edit message by it's id
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
      switch (keyName) {
        case messagesKey:
          _messages = loadedMessages;
          break;
        case trashKey:
          _trash = loadedMessages;
          break;
      }
    });
  }

  // add message into trash
  void _addMessageToTrash(int messageId) {
    setState(() {
      MessageService.addMessageToTrash(
        messages: _messages, 
        trash: _trash,
        messageId: messageId
      );
    });
    MessageService.saveMessages(_trash, trashKey);
  }

  // delete all messages in trash forever
  void _deleteMessageForever(int messageId) {
    setState(() {
      MessageService.deleteMessageForever(
        trash: _trash, 
        messageId: messageId
      );
    });
    MessageService.saveMessages(_trash, trashKey);
  }

  // recover a message from trash
  void _recoverMessageFromTrash(int messageId) {
    setState(() {
      MessageService.recoverMessageFromTrash(
        trash: _trash,
        messages: _messages, 
        messageId: messageId
      );
    });
    MessageService.saveMessages(_messages, messagesKey);
    MessageService.saveMessages(_trash, trashKey);
  }

  // clear trash
  void _clearTrash() {
    setState(() {
      MessageService.clearTrash(_trash);
    });
    MessageService.saveMessages(_trash, trashKey);
  }

  void _navigateToTrashPage() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => TrashPage(
          trash: _trash, 
          deleteMessageForever: _deleteMessageForever, 
          recoverMessageFromTrash: _recoverMessageFromTrash, 
          deleteAllMessagesInTrash: _clearTrash
        )
      )
    ).then((_) {
      setState(() {});
    });
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          searchController: _searchController,
          messages: _messages,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        trashCount: _trash.length, 
        onTrashSelected: () => _navigateToTrashPage(),
        onSearchSelected: () => _navigateToSearchPage(),
      ),
      body: Column(
        children: [
          // display ListTile with messages or placeholder if there is no messages
          Expanded(
            child: MessageList(
              messages: _messages,
              onItemTap: (context, messageId) {
                showContextMenu(
                  context: context, 
                  messageId: messageId, 
                  messages: _messages, 
                  removeMessage: _removeMessage, 
                  copyToClipboard: (messageId) => MessageService.copyToClipboard(_messages, messageId),
                  showEditDialog: (context, messageId) => showEditDialog(
                    context, messageId, _editMessageController, _messages, _editMessage),
                  pinMessage: (messageId) {
                    setState(() {
                      MessageService.togglePin(_messages, messageId);
                    });
                    MessageService.saveMessages(_messages, messagesKey);
                  }
                );
              }
            )
          ),
          // input field for adding messages
          MessageInput(
            controller: _messageController, 
            onSend: _addMessage
          )
        ],
      ),
    );
  }
}