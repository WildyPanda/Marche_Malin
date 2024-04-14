import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marche_malin/models/PostListElt.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/basicPost.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/services/service.dart';

class SearchPage extends StatefulWidget {
  List<BasicPost>? posts;
  SearchPage({this.posts, super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  Future<List<String>> futCategories = getCategories();
  List<String> categories = [];
  List<bool> categoriesCheck = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Title',
            ),
          ),
          TextFormField(
            controller: tagsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tags : tag1, tag2, etc',
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: futCategories,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    categories = snapshot.data!;
                    if(categories!.length != categoriesCheck.length){
                      for(int i =0; i < categories!.length; i++){
                        categoriesCheck.add(false);
                      }
                    }
                    return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (builder, index){
                          return CheckboxListTile(
                              title: Text(categories[index]),
                              value: categoriesCheck[index],
                              onChanged: (value){
                                setState(() {
                                  categoriesCheck[index] = value!;
                                });
                              }
                          );
                        }
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
          ),
          ElevatedButton(
              onPressed: () async {
                String title = titleController.text;
                List<String> nonTrimedTags = tagsController.text.split(",");
                List<String> tags = [];
                for (var element in nonTrimedTags)
                {
                  String trimed = element.trim();
                  if(trimed != "") {
                    tags.add(trimed);
                  }
                }
                List<String> categoriesDTO = [];
                for(int i = 0; i < categories.length; i++){
                  if(categoriesCheck[i]){
                    categoriesDTO.add(categories[i]);
                  }
                }
                List<BasicPost> posts = await searchPost(title, tags, categoriesDTO);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(posts: posts,)));
              },
              child: Text("Chercher")
          ),
          Expanded(
              child: Builder(
                builder: (context){
                  if(widget.posts != null){
                    return ListView.builder(
                        itemCount: widget.posts!.length,
                        itemBuilder: (builder, index){
                          return PostListElt(
                              post: widget.posts![index]
                          );
                        }
                    );
                  }
                  else{
                    return Placeholder();
                  }
                },
              )
          )
        ],
      ),
    );
  }
}
