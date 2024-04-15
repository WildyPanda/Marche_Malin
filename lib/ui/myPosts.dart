import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/PostListElt.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/basicPost.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/services/service.dart';
import '../globals.dart' as globals;

class MyPostsPage extends StatelessWidget {
  MyPostsPage({super.key});
  Future<List<BasicPost>> futPosts = getUserPost(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopMenuAppBar(),
      body: Visibility(
        visible: globals.logged,
        replacement: Center(
          child: Text("Vous devez être connecté pour voir vos annonces"),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Mes annonces",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black
                ),
              ),
              Expanded(child: FutureBuilder(
                future: futPosts,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<BasicPost>? posts = snapshot.data;
                    if(posts != null){
                      return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (builder, index){
                            return Column(
                              children: [
                                const SizedBox(height: 10,),
                                PostListElt(
                                  post: posts[index],
                                ),
                              ],
                            );
                          }
                      );
                    }
                    else{
                      return Placeholder();
                    }
                  }
                  else if(snapshot.hasError){
                    print(snapshot.error);
                    return const Center(
                      child: Text("Impossible de recuperrer les données"),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),)
            ],
          )
        )
      )
    );
  }
}