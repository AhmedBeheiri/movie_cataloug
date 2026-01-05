import 'package:movie_cataloug/features/movies/core/result.dart';

import '../domain/movie_repository.dart';
import '../data/movie_remote_data_source.dart';
import '../domain/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource dataSource;
  List<Movie>? _cachedMovies;

  MovieRepositoryImpl(this.dataSource);

  String _buildPosterUrl(String path) => 'https://image.tmdb.org/t/p/w500$path';

  @override
  Future<Result<List<Movie>>> getTrendingMovies() async {
    if (_cachedMovies != null) {
      return Success(_cachedMovies!);
    }

    final result = await dataSource.getTrendingMovies();

    return switch (result) {
      Success(data: final models) => () {
        _cachedMovies = models
            .where((m) => m.id != 0 && m.title.isNotEmpty)
            .map((m) => Movie(
          id: m.id,
          title: m.title,
          posterUrl: _buildPosterUrl(m.posterPath),
          overview: m.overview,
          voteAverage: m.voteAverage,
        ))
            .toList();

        return Success(_cachedMovies!);
      }(),
      Failure(message: final msg, exception: final ex) => Failure(msg, ex),
    };
  }

  @override
  Future<Result<Movie>> getMovieDetails(int id) async {
    final result = await dataSource.getMovieDetails(id);

    return switch (result) {
      Success(data: final model) =>
      (model!.id == 0 || model.title.isEmpty)
          ? Failure('Invalid movie data')
          : Success(Movie(
        id: model.id,
        title: model.title,
        posterUrl: _buildPosterUrl(model.posterPath),
        overview: model.overview,
        voteAverage: model.voteAverage,
      )),
      Failure(message: final msg, exception: final ex) => Failure(msg, ex),
    };
  }
}