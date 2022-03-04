class UserModel {
  String? email;
  String? uID;
  String? password;
  String? name;
  UserModel(
      {


        this.email,
        this.name,

        this.uID,
       });

  UserModel.fromJson (Map<String, dynamic> json) {
    email = json['email'];
    uID = json['uID'];
    password = json['password'];
    name = json['name'];

  }


}
