class SearchPostsDTO{
  String title;
  List<String> tags;
  List<String> categories;

  SearchPostsDTO({required this.title, required this.tags, required this.categories});

  Map<String, dynamic> toJson() {
    return {
      "title" : this.title,
      "tags" : this.tags,
      "categories" : this.categories
    };
  }
}