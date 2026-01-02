import '../data/movie_model.dart';
// Mistake: Domain entity depending on Data layer model

class Movie {
  final MovieModel model; // Clean Architecture violation: Entity wrapping Model

  Movie({required this.model});

  // Proxying properties
  int get id => model.id;
  String get title => model.title;
  String get posterUrl => model.fullPosterUrl; // Dependency on logic in Model
  String get overview => model.overview;
  double get voteAverage => model.voteAverage;
}
