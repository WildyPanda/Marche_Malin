
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/user.dart';

class CreatePostDTO {
  String title;
  AppUser user;
  List<XFile> images;
  String message;
  List<String> tags;
  List<String> categories;

  CreatePostDTO({required this.title, required this.user, required this.images, required this.message, required this.tags, required this.categories});

  Future<Map<String, dynamic>> toJson() async {
    List<String> imagesByte = [];
    for(var elt in this.images){
      var imageByte = await elt.readAsBytes();
      imagesByte.add(base64.encode(Uint8List.sublistView(imageByte)));
    }
    return {
      "title" : this.title,
      "user" : this.user.toJson(),
      "message" : this.message,
      "tags" : this.tags,
      "categories" : this.categories,
      "images" : imagesByte,
    };
  }
}