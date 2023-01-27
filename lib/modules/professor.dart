class Professor{
  final String _email;
  final String _name;
  final String _surname;

  Professor(this._email, this._name, this._surname);

  factory Professor.fromJson(Map<String,dynamic> json){
    return Professor(
      json['email'],
      json['name'],
      json['surname']
    );
  }

  String get surname => _surname;

  String get name => _name;

  String get email => _email;

  @override
  String toString() {
    return 'Professor{email: $_email, name: $_name, surname: $_surname}';
  }

  String toStringDropDown(){
    return this.name+" "+this.surname;
}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Professor &&
          runtimeType == other.runtimeType &&
          _email == other._email;

  @override
  int get hashCode => _email.hashCode;

  int compareTo(Professor other){
    return ("$name$_surname").compareTo("${other.name}${other.surname}");
  }
}