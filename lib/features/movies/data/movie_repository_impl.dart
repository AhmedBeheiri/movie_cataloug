import '../domain/movie_repository.dart';
import '../data/movie_remote_data_source.dart';
import '../domain/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource dataSource;

  MovieRepositoryImpl(this.dataSource);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    final models = await dataSource.getTrendingMovies();
    // Mistake: Manual mapping here instead of Mapper class
    return models.map((m) => Movie(model: m)).toList();
  }

  @override
  Future<Movie?> getMovieDetails(int id) async {
    final model = await dataSource.getMovieDetails(id);
    if (model == null) return null;
    return Movie(model: model);
  }
}
