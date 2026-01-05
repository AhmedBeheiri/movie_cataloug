

import '../core/result.dart';
import 'movie.dart';

abstract class MovieRepository {
  Future<Result<List<Movie>>> getTrendingMovies();
  Future<Result<Movie>> getMovieDetails(int id);
}
