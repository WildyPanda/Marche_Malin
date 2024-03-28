import 'package:flutter/material.dart';
import 'package:marche_malin/models/TopMenu.dart';

class TopMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopMenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TopMenu(),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
