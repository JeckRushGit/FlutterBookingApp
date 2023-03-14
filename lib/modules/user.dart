
import 'package:jwt_decode/jwt_decode.dart';


class User {
  late final String email;
  late final String name;
  late final String surname;
  late final String password;
  late final String role;
  late final String birthday;
  late final String profession;

  User(this.email, this.name, this.surname, this.password, this.role,
      this.birthday, this.profession);

  User.fake();

  User.safe(String email,String name,String surname){
    this.email = email;
    this.name = name;
    this.surname = surname;
    this.password = "";
    this.role = "";
    this.birthday = "";
    this.profession = "";
  }

  factory User.fromJson(Map<String,dynamic> json){
    return User.safe(json['email'], json['name'], json['surname']);
  }

  User.fromToken(String token){
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    email = payload["email"];
    name = payload["name"];
    surname = payload["surname"];
    password = payload["password"];
    role = payload["role"];
    birthday = payload["birthday"];
    profession = payload["profession"];
  }

  int compareTo(User other){
    return this.email.compareTo(other.email);
  }


  @override
  String toString() {
    return 'User{email: $email, name: $name, surname: $surname, password: $password, role: $role, birthday: $birthday, profession: $profession}';
  }
}
