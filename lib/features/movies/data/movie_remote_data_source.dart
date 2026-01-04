import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import 'movie_model.dart';

class MovieRemoteDataSource {

  /// api key and base url moved to constants.dart
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/trending/movie/week?api_key=${Constants.apiKey}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((e) => MovieModel.fromJson(e)).toList();
      } else {

        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {

      print(e);
      return [];
    }
  }

  Future<MovieModel?> getMovieDetails(int id) async {
     try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/movie/$id?api_key=${Constants.apiKey}'),
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
