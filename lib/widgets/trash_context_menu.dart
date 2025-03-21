// display modal bottom sheet for deleting or recovering message in trash

import 'package:flutter/material.dart';

void showTrashDialog(
  BuildContext context,
  int trashCount,
  List<Map<String, dynamic>> trash,
  Function(int) deleteMessageForever,
  Function(int) recoverMessageFromTrash,
  Function() deleteAllMessagesInTrash,
  Function(Function()) setState
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade400
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trash (${trash.length})', style: TextStyle(fontSize: 20, color: Colors.white)),
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
                                  setModalState(() {
                                    deleteAllMessagesInTrash();
                                  });
                                  Navigator.pop(context);
                                }, 
                                child: const Text('OK')
                              )
                            ],
                          )
                        );
                      }, 
                      icon: const Icon(Icons.delete_outline, color: Colors.white)
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: trash.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: ListTile(
                        title: Text(trash[index]['message']),
                        trailing: Text(trash[index]['date']),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child:  Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.delete_forever),
                                      title: const Text('Delete forever'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setModalState(() {
                                          deleteMessageForever(trash[index]['id']);
                                        });
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.restore_from_trash),
                                      title: const Text('Recover'),
                                      onTap: () {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                        setState(() {
                                          recoverMessageFromTrash(trash[index]['id']);
                                        });
                                      },
                                    )
                                  ],
                                )
                              );
                            }
                          );
                        },
                      )
                    );
                  }
                )
              )
            ],
          );
        }
      );
    }
  );
}