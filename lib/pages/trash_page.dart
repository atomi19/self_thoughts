import 'package:flutter/material.dart';

class TrashPage extends StatefulWidget {
  final List<Map<String, dynamic>> trash;
  final Function(int) deleteMessageForever;
  final Function(int) recoverMessageFromTrash;
  final Function() deleteAllMessagesInTrash;

  const TrashPage({
    super.key,
    required this.trash,
    required this.deleteMessageForever,
    required this.recoverMessageFromTrash,
    required this.deleteAllMessagesInTrash}
  );

  @override
  TrashPageState createState() => TrashPageState();
}

class TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red.shade400,
        title: Text('Trash', style: TextStyle(fontSize: 20, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete all items in Trash?'),
                  content: const Text('All messages in Trash will be deleted!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.deleteAllMessagesInTrash();
                        });
                        Navigator.pop(context);
                      }, 
                      child: const Text('OK')
                    )
                  ],
                )
              );
            }, 
            icon: const Icon(Icons.delete_outline)
          )
        ],
      ),
      body: Column(
        children: [
          widget.trash.isEmpty
          ? Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('No items in trash', style: TextStyle(fontSize: 25)),
            )
          )
          : Expanded(
            child: ListView.builder(
              itemCount: widget.trash.length,
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
                            alignment: Alignment.topRight,
                            child: Text(widget.trash[index]['date']),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(widget.trash[index]['message']),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child:  Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.delete_forever),
                                      title: const Text('Delete forever'),
                                      onTap: () {
                                        setState(() {
                                          widget.deleteMessageForever(widget.trash[index]['id']);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.restore_from_trash),
                                      title: const Text('Recover'),
                                      onTap: () {
                                        setState(() {
                                          widget.recoverMessageFromTrash(widget.trash[index]['id']);
                                        });
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                              );
                            }
                          );
                        },
                      )
                    ],
                  )
                );
              }
            )
          )
        ],
      ),
    );
  }
}