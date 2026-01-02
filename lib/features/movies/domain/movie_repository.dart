
// Mistake: Missing proper imports or types sometimes, but let's keep it simple for now.
// Mistake: Returning Model/Entity mismatch or Future<dynamic>
import 'movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<Movie?> getMovieDetails(int id);
}
