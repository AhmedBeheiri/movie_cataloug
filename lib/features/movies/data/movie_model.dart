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
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }


  String get fullPosterUrl {

    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
