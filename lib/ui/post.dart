import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/services/service.dart';
import 'package:marche_malin/ui/EditPost.dart';

class PostPage extends StatefulWidget {
  final int postIndex;

  const PostPage({Key? key, required this.postIndex}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<Post> futPost;

  @override
  void initState() {
    super.initState();
    futPost = getPost(widget.postIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: FutureBuilder<Post>(
        future: futPost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Impossible de récupérer les données"));
          }

          if (snapshot.hasData) {
            Post post = snapshot.data!;

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return EditPost(post: post);
                    }));
                    setState(() {
                      futPost = getPost(widget.postIndex);
                    });
                  },
                  child: Text("Editer"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  post.title,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    itemCount: post.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // Access the image at the current index
                      ImageProvider image = post.images[index].image;
                      return Image(
                        image: image,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  post.user.username.isNotEmpty ? post.user.username : post.user.email,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(post.message),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    itemCount: post.tags.length,
                    itemBuilder: (context, index) {
                      return Text(post.tags[index]);
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 100.0,
                  child: ListView.builder(
                    itemCount: post.categories.length,
                    itemBuilder: (context, index) {
                      return Text(post.categories[index]);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("Aucune donnée disponible"));
          }
        },
      ),
    );
  }
}
