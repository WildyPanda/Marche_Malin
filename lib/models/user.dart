class AppUser{
  String uuid;
  String username;
  String email;
  String phone;

  AppUser({required this.uuid, required this.username, required this.email, required this.phone});
  AppUser.fromJson(Map<String, dynamic> json):
    this.username = json["username"]??"",
    this.uuid = json["uuid"]??"",
    this.email = json["email"]??"",
    this.phone = json["phoneNb"]??"";

}