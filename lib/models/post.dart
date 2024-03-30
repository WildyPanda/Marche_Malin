import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marche_malin/models/user.dart';

class Post{
  String title;
  AppUser user;
  List<Image> images;
  String message;
  List<String> tags;
  List<String> categories;

  Post({required this.title, required this.user, required this.images, required this.message, required this.tags, required this.categories});

  Post.fromJson(Map<String, dynamic> json):
    this.title = json['title']??"",
    this.user = AppUser.fromJson(json['user']),
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