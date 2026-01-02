class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '', // Bad: Should probably handle full url here or later, but empty string is risky
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }

  // Mistake: Logic inside data model used for UI formatting
  String get fullPosterUrl {
    // Hardcoded base URL in model - Bad practice
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
