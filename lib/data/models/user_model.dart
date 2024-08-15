/* class User {
  final String id;
  final String username;
  final String email;
  final String profilePicture;
  final String fcmToken;
  final String bio;
  final List<String> favoriteDishes;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fcmToken,
    required this.profilePicture,
    required this.bio,
    required this.favoriteDishes,
  });

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      bio: json['bio'] ?? '',
      favoriteDishes: List<String>.from(json['favoriteDishes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profile_picture': profilePicture,
      'bio': bio,
      'fcmToken': fcmToken,
      'favoriteDishes': favoriteDishes,
    };
  }
}
 */

class User {
  final String id;
  final String username;
  final String email;
  final String profilePicture;
  final String fcmToken;
  final String bio;
  final List<String> favoriteDishes;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fcmToken,
    required this.profilePicture,
    required this.bio,
    required this.favoriteDishes,
  });

  factory User.fromJson(Map<String, dynamic> json, ) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      bio: json['bio'] ?? '',
      favoriteDishes: List<String>.from(json['favoriteDishes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profile_picture': profilePicture,
      'bio': bio,
      'fcmToken': fcmToken,
      'favoriteDishes': favoriteDishes,
    };
  }

  // Add the copyWith method
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profilePicture,
    String? fcmToken,
    String? bio,
    List<String>? favoriteDishes,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      fcmToken: fcmToken ?? this.fcmToken,
      bio: bio ?? this.bio,
      favoriteDishes: favoriteDishes ?? this.favoriteDishes,
    );
  }
}
