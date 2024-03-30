import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/services/service.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}
/////////////////////////////////////////////////////////////////////
//////// ATTENTION NE PAS SUPPRIMER AVANT D'AVOIR IMPLEMENTER UN AJOUT D'IMAGE DANS LE FRONT
/////////////////////////////////////////////////////////////////////

class _AddImagePageState extends State<AddImagePage> {
  List<XFile> images = [];

  //Post post;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Column(
        children: [
          ImageInput(
            allowEdit: true,
            allowMaxImage: 3,
            initialImages: images,
            onImageSelected: (image, index) {
              if(!images.contains(image)){
                setState(() {
                  images.add(image);
                });
              }
            },
            onImageRemoved: (image, index) {
              if(images.contains(image)){
                setState(() {
                  images.remove(image);
                });
              }
            },

          ),
          ElevatedButton(
              onPressed: () {
                for (var element in images) {
                  AddImage(element);
                }
              },
              child: const Text("Ajouter image")
          )
        ],
      ),
    );
  }
}
