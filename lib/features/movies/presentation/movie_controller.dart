import 'package:flutter/material.dart';
import 'package:movie_cataloug/features/movies/domain/get_trending_movies.dart';
import 'package:movie_cataloug/features/movies/domain/movie.dart';
import 'package:movie_cataloug/features/movies/data/movie_repository_impl.dart';
import 'package:movie_cataloug/features/movies/data/movie_remote_data_source.dart';

class MovieController extends ChangeNotifier {

  // static final MovieController _instance = MovieController._internal();
  // factory MovieController() => _instance;
  // MovieController._internal();

  final GetTrendingMovies _getTrendingMovies;

  /// Remove singleton pattern - inject dependencies in constructor
  MovieController(this._getTrendingMovies);

  // BuildContext? context;

  List<Movie> movies = [];
  bool isLoading = false;

  /// context shall be passed and not stored in a variable to avoid memory leaks
  // void setContext(BuildContext c) {
  //   context = c;
  // }


  Future<void> fetchMovies() async {
    isLoading = true;
    notifyListeners();

    try {
      /// fake delay is bad for performance
      // await Future.delayed(Duration(seconds: 2));
      movies = await _getTrendingMovies();
    } catch (e) {
      /// Clear movies list on error
      movies = [];
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    /// Clean up resources before disposal
    /// Clear list to free memory references
    movies.clear();
    super.dispose();
  }
}
