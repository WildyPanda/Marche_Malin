import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/user.dart';

class BasicPost{
  int id;
  String title;
  AppUser user;
  String message;
  Image image;

  BasicPost({required this.id, required this.title, required this.user, required this.message, required this.image});

  BasicPost.fromJson(Map<String, dynamic> json):
        this.id = json['idPost'],
        this.title = json['title']??"",
        this.user = AppUser.fromJson(json['user']),
        this.message = json['message']??"",
        this.image = getImageFromJson(json);
  
  static Image getImageFromJson(json){
    try{
      return Image.memory(base64Decode(json["image"]["image"]), fit: BoxFit.cover,);
    }
    catch(e){
      return Image.network("https://upload.wikimedia.org/wikipedia/commons/3/33/White_square_with_question_mark.png", fit: BoxFit.cover,);
    }
  }

}