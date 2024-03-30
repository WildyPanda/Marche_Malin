import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/CreatePostDTO.dart';
import 'package:marche_malin/services/service.dart';
import '../globals.dart' as globals;

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  List<XFile> images = [];
  Future<List<String>> futCategories = getCategories();
  List<String> categories = [];
  List<bool> categoriesCheck = [];
  String res = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Visibility(
        visible: globals.logged,
        replacement: Center(
          child: Text("Vous devez etre connecté pour creer une annonce"),
        ),
        child: Column(
          children: [
            Visibility(
              visible: this.res != "",
              child: Text(res),
            ),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
            ImageInput(
              allowEdit: true,
              allowMaxImage: 5,
              initialImages: images,
              onImageSelected: (image, index) {
                if(!images.contains(image)){
                  setState(() {
                    images.add(image);
                  });
                }
              },
              onImageRemoved: (image, index) {
                if(images.contains(image)){
                  setState(() {
                    images.remove(image);
                  });
                }
              },

            ),
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Message',
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
                // verification des input
                if(titleController.text == ""){
                  setState(() {
                    res = "Le titre doit etre renseigné";
                  });
                  return;
                }
                if(messageController.text == ""){
                  setState(() {
                    res = "Le message doit etre renseigné";
                  });
                  return;
                }
                if(tagsController.text == ""){
                  setState(() {
                    res = "Les tags doivent etre renseigné";
                  });
                  return;
                }
                List<String> nonTrimedTags = tagsController.text.split(",");
                List<String> tags = [];
                for (var element in nonTrimedTags) {tags.add(element.trim());}
                List<String> categoriesDto = [];
                print(categories.length);
                print(categoriesCheck.length);
                if(categories.length != categoriesCheck.length){
                  setState(() {
                    res = "Internal error : categories.length != categoriesCheck.length";
                  });
                  return;
                }
                for(int i = 0; i < categories.length; i++){
                  if(categoriesCheck[i]){
                    categoriesDto.add(categories[i]);
                  }
                }
                CreatePostDTO dto = CreatePostDTO(title: titleController.text, user: await getUser(), images: images, message: messageController.text, tags: tags, categories: categoriesDto);
                createPost(dto);
              },
              child: const Text("Creer l'annonce")
            )
          ],
        ),
      )
    );
  }
}
