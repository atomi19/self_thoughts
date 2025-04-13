// app bar for main_page.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final int trashCount;
  final Function onTrashSelected;
  final Function onSearchSelected;

  const CustomAppBar({
    super.key,
    required this.trashCount, 
    required this.onTrashSelected,
    required this.onSearchSelected
    });
  
  @override
  Size get preferredSize => Size.fromHeight(50);

  PopupMenuItem<String> _buildMenuItem(String text, String value,IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text('Self Thoughts'),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.menu),
          itemBuilder: (context) => [
            _buildMenuItem('Search', 'search', Icons.search),
            _buildMenuItem('Trash', 'trash', Icons.delete_outline)
          ],
          onSelected: (value) {
            switch (value) {
              case 'search':
                onSearchSelected();
                break;
              case 'trash':
                onTrashSelected();
                break;
            }
          },
        )
      ],
    );
  }
}