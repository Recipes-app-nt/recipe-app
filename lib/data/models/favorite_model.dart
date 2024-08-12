class Favorite {
  final Map<String, bool> favorites;

  Favorite({required this.favorites});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favorites: Map<String, bool>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return favorites;
  }
}
