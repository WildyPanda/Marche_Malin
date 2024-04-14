import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/basicPost.dart';
import 'package:marche_malin/models/dtos/CreatePostDTO.dart';
import 'package:marche_malin/models/dtos/ModifyPostDTO.dart';
import 'package:marche_malin/models/dtos/SearchPostsDTO.dart';
import 'package:marche_malin/models/dtos/UserDTOs.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/models/user.dart';
import '../globals.dart' as globals;
import 'package:flutter/services.dart';

Future<void> AddImage(XFile image) async {
  // I stopped in the middle of creating an example posts in database.
  // This methods if for adding an image to the database.
  // the problem is converting the image to byte-array
  // there might be some problems with the back too because posts/public/get return error.
  var imageBytes = await image.readAsBytes();
  var header = globals.getHeaderContentType();
  Object body = {
    "id_image" : null,
    "id_post" : 0,
    "image" : base64.encode(Uint8List.sublistView(imageBytes))
  };
  var resp = await http.post(globals.getUrl("images/public/addImage"), headers: header, body: json.encode(body));
  print(resp.body);
}

void SaveEmail(String? email) async {
  var header = globals.getHeaderContentType();
  SaveEmailDTO body = SaveEmailDTO(email!);
  http.post(globals.getUrl("user/UpdateEmail"), headers: header, body: json.encode(body.toJson()));
}

Future<AppUser> getUser() async {
  var header = globals.getHeader();
  var resp = await http.get(globals.getUrl("user/get"), headers: header);
  var json = jsonDecode(utf8.decode(resp.bodyBytes));
  return AppUser.fromJson(json);
}

Future<Post> getPost(int id) async{
  var header = globals.getHeader();
  var resp = await http.get(globals.getUrl("posts/public/get/$id"), headers: header);
  var json = jsonDecode(utf8.decode(resp.bodyBytes));
  return Post.fromJson(json);
}

Future<List<String>> getCategories() async {
  var header = globals.getHeader();
  var resp = await http.get(globals.getUrl("category/public/getAll"), headers: header);
  List<dynamic> categoriesJson = jsonDecode(utf8.decode(resp.bodyBytes));
  List<String> categories = [];
  for(String elt in categoriesJson){
    categories.add(elt);
  }
  return categories;
}

Future<void> createPost(CreatePostDTO dto) async {
  var header = globals.getHeaderContentType();
  var resp = await http.post(globals.getUrl("posts/add"), headers: header, body: json.encode( await dto.toJson()));
}

Future<void> modifyPost(ModifyPostDTO dto) async {
  var header = globals.getHeaderContentType();
  var resp = await http.post(globals.getUrl("posts/modify"), headers: header, body: json.encode( await dto.toJson()));
  // CREER endpoint modify dans post controller
  // pour les images voir si il y a un moyen de verifier les existantes sinon supprimer toutes les images et enregistrer les nouvelles a la place
  // pour les tags / categories : si existe -> ignore sinon -> creer. comme dans CreatePost.
}

Future<List<BasicPost>> searchPost(String title, List<String> tags, List<String> categories) async {
  SearchPostsDTO dto = SearchPostsDTO(title: title, tags: tags, categories: categories);
  var header = globals.getHeaderContentType();
  var resp = await http.post(globals.getUrl("posts/public/SearchPosts"), body: json.encode(dto.toJson()), headers: header);
  List<dynamic> jsonList = jsonDecode(utf8.decode(resp.bodyBytes));
  print(jsonList.length);
  print(utf8.decode(resp.bodyBytes));
  List<BasicPost> posts = [];
  for(dynamic elt in jsonList){
    posts.add(BasicPost.fromJson(elt));
  }
  return posts;
}