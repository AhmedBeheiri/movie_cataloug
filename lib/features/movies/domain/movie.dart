import '../data/movie_model.dart';


class Movie {
  final MovieModel model;

  Movie({required this.model});

  // Proxying properties
  int get id => model.id;
  String get title => model.title;
  String get posterUrl => model.fullPosterUrl;
  String get overview => model.overview;
  double get voteAverage => model.voteAverage;
}
