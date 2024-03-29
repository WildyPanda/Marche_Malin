class SaveEmailDTO {
  String email;

  SaveEmailDTO(this.email);

  Map<String, dynamic> toJson() => {
    'email' : email
  };
}

class SavePhoneDTO {
  String phoneNb;

  SavePhoneDTO(this.phoneNb);

  Map<String, dynamic> toJson() => {
    'phoneNb' : phoneNb
  };
}

class SaveUsernameDTO {
  String username;

  SaveUsernameDTO(this.username);

  Map<String, dynamic> toJson() => {
    'username' : username
  };
}