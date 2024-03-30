import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/services/service.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<Post>? futPost;


  @override
  Widget build(BuildContext context) {
    futPost ??= getPost(0);
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: FutureBuilder(
        future: futPost,
        builder: (context, snapshot){
          if(snapshot.hasData){
            Post? post = snapshot.data;
            return Column(
              children: [
                // The title
                Expanded(child: Text(post!.titre)),
                // The images
                // The Listview must be in a widget with defined size, else it create errors
                Expanded(
                  child: Builder(builder: (context){
                      return ListView.builder(
                        itemCount: post.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return Image(
                            image: post.images[0].image,
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    }),
                ),
                // The message
                Expanded(child: Text(post.message)),
                // The categories
                // Try to make them clickable to search by categories
                // The Listview must be in a widget with defined size, else it create errors
                Expanded(
                  child: Builder(builder: (context){
                    return ListView.builder(
                      itemCount: post.tags.length,
                      itemBuilder: (context, index){
                        return Text(post.tags[index]);
                      },
                    );
                  }),
                ),
                // The tags
                // Try to make them clickable to search by tags
                // The Listview must be in a widget with defined size, else it create errors
                Expanded(
                  child: Builder(builder: (context){
                    return ListView.builder(
                      itemCount: post.categories.length,
                      itemBuilder: (context, index){
                        return Text(post.categories[index]);
                      },
                    );
                  }),
                ),
              ],
            );
          }
          else if(snapshot.hasError){
            print(snapshot.error);
            return const Center(
              child: Text("Impossible de recuperrer les données"),
            );
          }
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
