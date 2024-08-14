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

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      bio: json['bio'] ?? '',
      favoriteDishes: List<String>.from(json['favorite_dishes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profile_picture': profilePicture,
      'bio': bio,
      'fcmToken': fcmToken,
      'favorite_dishes': favoriteDishes,
    };
  }
}
