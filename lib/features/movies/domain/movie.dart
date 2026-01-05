// class Movie {
//   final MovieModel model;
//
//   Movie({required this.model});
//
//   // Proxying properties
//   int get id => model.id;
//   String get title => model.title;
//   String get posterUrl => model.fullPosterUrl;
//   String get overview => model.overview;
//   double get voteAverage => model.voteAverage;
// }

/// Domain entity - NOT depending on data layer
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.voteAverage,
  });
}
