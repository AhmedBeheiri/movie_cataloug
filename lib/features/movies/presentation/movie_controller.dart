import 'package:flutter/material.dart';
import 'package:movie_cataloug/features/movies/domain/get_trending_movies.dart';
import 'package:movie_cataloug/features/movies/domain/movie.dart';
import 'package:movie_cataloug/features/movies/data/movie_repository_impl.dart';
import 'package:movie_cataloug/features/movies/data/movie_remote_data_source.dart';

class MovieController extends ChangeNotifier {
  // Mistake: Singleton pattern for a Controller/ViewModel
  static final MovieController _instance = MovieController._internal();
  factory MovieController() => _instance;
  MovieController._internal();

  // Mistake: Holding context in controller (Memory leak risk)
  BuildContext? context;

  List<Movie> movies = [];
  bool isLoading = false;

  void setContext(BuildContext c) {
    context = c;
  }

  // Mistake: Direct instantiation of dependencies (No DI)
  final GetTrendingMovies _getTrendingMovies = GetTrendingMovies(
    MovieRepositoryImpl(MovieRemoteDataSource()),
  );

  Future<void> fetchMovies() async {
    isLoading = true;
    notifyListeners();

    try {
      // Mistake: Using a delay to simulate slowness or just bad UX
      await Future.delayed(Duration(seconds: 2)); 
      movies = await _getTrendingMovies();
    } catch (e) {
      // Mistake: No error handling for UI
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
