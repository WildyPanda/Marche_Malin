import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_input/image_input.dart';
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