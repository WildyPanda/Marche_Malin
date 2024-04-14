import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/basicPost.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/ui/post.dart';

class PostListElt extends StatelessWidget {
  BasicPost post;

  PostListElt({required this.post ,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(postIndex: post.id)));
        },
        child: Row(
          children: [
            post.image,
            Text(post.title),
          ],
        ),
      )
    );
  }
}
