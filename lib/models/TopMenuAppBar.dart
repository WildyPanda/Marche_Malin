import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenu.dart';

class TopMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopMenuAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Center(
              child: TopMenu(), // Utiliser TopMenu ici
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange, // Couleur de fond de l'AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
