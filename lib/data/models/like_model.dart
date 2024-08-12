class Like {
  final Map<String, bool> likes;

  Like({required this.likes});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      likes: Map<String, bool>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return likes;
  }
}
