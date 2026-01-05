import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:movie_cataloug/features/movies/core/result.dart';
import '../core/constants.dart';
import 'movie_model.dart';

class MovieRemoteDataSource {

  /// api key and base url moved to constants.dart
  Future<Result<List<MovieModel>>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/trending/movie/week?api_key=${Constants.apiKey}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        final movies = results.map((e) => MovieModel.fromJson(e)).toList();
        return Success(movies);
      } else {
        return Failure('Server error: ${response.statusCode}');
      }
    } on SocketException {
      return Failure('No internet connection');
      } catch (e) {
        return Failure('An unexpected error occurred');
      }
  }

  Future<Result<MovieModel?>> getMovieDetails(int id) async {
     try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/movie/$id?api_key=${Constants.apiKey}'),
      );

      if (response.statusCode == 200) {
        final movie = MovieModel.fromJson(json.decode(response.body));
        return Success(movie);
      } else {
        return Failure('Failed to fetch movie details');
      }
    }  on SocketException {
       return Failure('No internet connection');
     } catch (e) {
       return Failure('An unexpected error occurred');
     }
  }
}
