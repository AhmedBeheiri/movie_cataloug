import 'package:movie_cataloug/features/movies/core/result.dart';

import 'movie_repository.dart';
import 'movie.dart';

class GetTrendingMovies {
  final MovieRepository repository;

  GetTrendingMovies(this.repository);

  Future<Result<List<Movie>>> call() {
    return repository.getTrendingMovies();
  }
}
