class AppUser{
  String username;
  String email;
  String phone;

  AppUser({required this.username, required this.email, required this.phone});
  AppUser.fromJson(Map<String, dynamic> json):
    this.username = json["username"]??"",
    this.email = json["email"]??"",
    this.phone = json["phoneNb"]??"";

}