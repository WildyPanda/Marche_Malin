import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class Post{
  String titre;
  List<Image> images;
  String message;
  List<String> tags;
  List<String> categories;

  Post({required this.titre, required this.images, required this.message, required this.tags, required this.categories});

  Post.fromJson(Map<String, dynamic> json):
    this.titre = json['titre']??"",
    this.message = json['message']??"",
    this.tags = getStrings(json['tags']??[]),
    this.categories = getStrings(json['categories']??[]),
    this.images = getImages(json['images']??[]);

  static List<String> getStrings(List<dynamic> dynamics){
    List<String> strings = [];
    for(var element in dynamics){
      strings.add(element);
    }
    return strings;
  }

  static List<Image> getImages(var imagesBytes){
    List<Image> images = [];
    for(var element in imagesBytes){
      images.add(Image.memory(base64Decode(element["image"])));
    };
    return images;
  }
}