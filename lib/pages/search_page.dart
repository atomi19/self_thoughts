// search page
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final TextEditingController searchController;
  final List<Map<String, dynamic>> messages;

  const SearchPage({
    super.key,
    required this.searchController,
    required this.messages});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  // list to store messages matching the search query
  List<Map<String, dynamic>> filteredMessages = [];

  // filter messages based on search query
  void searchMessage(String searchQuery) {
    setState(() {
      filteredMessages = widget.messages
        .where((message) => message['message'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                // search text field
                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    onChanged: (query) =>  searchMessage(widget.searchController.text),
                    decoration: InputDecoration(
                      hintText: 'Search your thoughts',
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      border: OutlineInputBorder(),
                      suffixIcon: widget.searchController.text.isNotEmpty
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              widget.searchController.clear();
                            });
                          }, 
                          icon: const Icon(Icons.cancel, size: 20)
                        )
                      : null
                    ),
                  )
                ),
                SizedBox(width: 10),
                // cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.searchController.clear();
                  }, 
                  child: const Text('Cancel')
                )
              ],
            )
          ),
          Expanded(
            child: widget.searchController.text.trim().isEmpty 
            // if search text field is empty, show a placeholder message
            ? Center(child: Text('Search your thoughts', style: TextStyle(fontSize: 25)))
            : filteredMessages.isEmpty
            // if no matching messages found(so filteredMessages is empty), show 'No thoughts found'
            ? Center(child: Text('No thoughts found', style: TextStyle(fontSize: 25)))
            // if matching message found(it's going to be in filteredMessages), then display it in ListTile
            : ListView.builder(
              itemCount: filteredMessages.length,
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
                            child: Text(filteredMessages[index]['date']),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(filteredMessages[index]['message']),
                      )
                    ],
                  ),
                );
              }
            )
          )
        ],
      ),
    ));
  }
}