class SaveEmailDTO {
  String email;

  SaveEmailDTO(this.email);

  Map<String, dynamic> toJson() => {
    'email' : email
  };
}