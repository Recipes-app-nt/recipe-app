class Comment {
  final String userId;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user_id'] ?? '',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
