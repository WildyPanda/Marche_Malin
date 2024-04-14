import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/CreatePostDTO.dart';
import 'package:marche_malin/services/service.dart';
import '../globals.dart' as globals;

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Visibility(
          visible: globals.logged,
          replacement: Center(
            child: Text("Vous devez être connecté pour créer une annonce"),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (res.isNotEmpty) Text(res),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Titre',
                ),
              ),
              const SizedBox(height: 10),
              ImageInput(
                allowEdit: true,
                allowMaxImage: 5,
                initialImages: images,
                onImageSelected: (image, index) {
                  if (!images.contains(image)) {
                    setState(() {
                      images.add(image);
                    });
                  }
                },
                onImageRemoved: (image, index) {
                  if (images.contains(image)) {
                    setState(() {
                      images.remove(image);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Message',
                ),
              ),
              const SizedBox(height: 10),
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
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      categories = snapshot.data!;
                      if (categoriesCheck.isEmpty) {
                        categoriesCheck = List<bool>.filled(categories.length, false);
                      }
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (builder, index) {
                          return CheckboxListTile(
                            title: Text(categories[index]),
                            value: categoriesCheck[index],
                            onChanged: (value) {
                              setState(() {
                                categoriesCheck[index] = value!;
                              });
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text("Impossible de récupérer les données"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        messageController.text.isEmpty ||
                        tagsController.text.isEmpty) {
                      setState(() {
                        res = "Tous les champs doivent être renseignés";
                      });
                      return;
                    }
                    List<String> tags = tagsController.text.split(',').map((tag) => tag.trim()).toList();
                    List<String> categoriesDto = [];
                    for (int i = 0; i < categories.length; i++) {
                      if (categoriesCheck[i]) {
                        categoriesDto.add(categories[i]);
                      }
                    }
                    CreatePostDTO dto = CreatePostDTO(
                      title: titleController.text,
                      user: await getUser(),
                      images: images,
                      message: messageController.text,
                      tags: tags,
                      categories: categoriesDto,
                    );
                    await createPost(dto);
                    // Réinitialisation des champs après la soumission
                    setState(() {
                      titleController.clear();
                      messageController.clear();
                      tagsController.clear();
                      images.clear();
                      categoriesCheck = List<bool>.filled(categories.length, false);
                    });
                  },
                  child: const Text("Créer l'annonce"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
