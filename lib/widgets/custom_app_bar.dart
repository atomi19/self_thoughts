// app bar for main_page.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final int trashCount;
  final Function onTrashSelected;

  const CustomAppBar({required this.trashCount, required this.onTrashSelected, super.key});
  
  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text('Self Thoughts'),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.menu),
          itemBuilder: (BuildContext context) => <PopupMenuEntry> [
            PopupMenuItem(
              value: 'trash',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline),
                  SizedBox(width: 5),
                  Text('Trash')
                ],
              )
            )
          ],
          onSelected: (value) {
            if(value == 'trash') {
              onTrashSelected();
            }
          },
        )
      ],
    );
  }
}