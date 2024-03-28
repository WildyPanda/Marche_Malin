import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text("Menu"),
        Expanded(child: Center(
          child: Text("Marche Malin"),
        ))

      ],
    );
  }
}
