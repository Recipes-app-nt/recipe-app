import 'dart:convert';

class User {
  String idToken;
  String email;
  String refreshToken;
  DateTime expiresIn;
  String localId;
  User({
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idToken': idToken,
      'email': email,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn.toString(),
      'localId': localId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idToken: map['idToken'] as String,
      email: map['email'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresIn: DateTime.now().add(
        Duration(
          seconds: int.parse(
            map['expiresIn'],
          ),
        ),
      ),
      localId: map['localId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
