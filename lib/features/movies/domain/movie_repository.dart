

import 'movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<Movie?> getMovieDetails(int id);
}
