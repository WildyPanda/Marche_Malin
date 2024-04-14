import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';
import 'package:marche_malin/models/TopMenuAppBar.dart';
import 'package:marche_malin/models/dtos/ModifyPostDTO.dart';
import 'package:marche_malin/models/post.dart';
import 'package:marche_malin/services/service.dart';
import '../globals.dart' as globals;

class EditPost extends StatefulWidget {
  final Post post;
  const EditPost({required this.post, Key? key}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  List<XFile> images = [];
  Future<List<String>> futCategories = getCategories();
  List<String> categories = [];
  List<bool> categoriesCheck = [];
  String res = "";
  bool init = false;
  bool initCat = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      titleController.text = widget.post.title;
      messageController.text = widget.post.message;
      tagsController.text = widget.post.tags.join(', ');
      images.addAll(widget.post.imagesBytes);
      init = true;
    }

    return Scaffold(
      appBar: TopMenuAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Visibility(
          visible: globals.logged,
          replacement: Center(
            child: Text("Vous devez être connecté pour modifier une annonce"),
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
                      if (categories.length != categoriesCheck.length) {
                        categoriesCheck = List<bool>.filled(categories.length, false);
                      }
                      if (categories.isNotEmpty && widget.post.categories.isNotEmpty && !initCat) {
                        for (String elt in widget.post.categories) {
                          int index = categories.indexOf(elt);
                          if (index != -1) {
                            categoriesCheck[index] = true;
                          }
                        }
                        initCat = true;
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      setState(() {
                        res = "Le titre doit être renseigné";
                      });
                      return;
                    }
                    if (messageController.text.isEmpty) {
                      setState(() {
                        res = "Le message doit être renseigné";
                      });
                      return;
                    }
                    if (tagsController.text.isEmpty) {
                      setState(() {
                        res = "Les tags doivent être renseignés";
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
                    ModifyPostDTO dto = ModifyPostDTO(
                      id: widget.post.id,
                      title: titleController.text,
                      user: await getUser(),
                      images: images,
                      message: messageController.text,
                      tags: tags,
                      categories: categoriesDto,
                    );
                    await modifyPost(dto);
                    Navigator.pop(context);
                  },
                  child: const Text("Modifier l'annonce"),
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
