import '../domain/movie_repository.dart';
import '../data/movie_remote_data_source.dart';
import '../domain/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource dataSource;

  MovieRepositoryImpl(this.dataSource);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    final models = await dataSource.getTrendingMovies();
    /// Prevents creating Movie domain objects with empty or null
    return models
        .where((m) => m.id != 0 && m.title.isNotEmpty)
        .map((m) => Movie(model: m))
        .toList();
  }

  @override
  Future<Movie?> getMovieDetails(int id) async {
    final model = await dataSource.getMovieDetails(id);
    if (model == null) return null;
    /// Validate model has data before creating Movie
    if (model.id == 0 || model.title.isEmpty) return null;
    return Movie(model: model);
  }
}