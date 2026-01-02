import 'movie_repository.dart';
import 'movie.dart';

class GetTrendingMovies {
  final MovieRepository repository;

  GetTrendingMovies(this.repository);

  Future<List<Movie>> call() {
    return repository.getTrendingMovies();
  }
}
