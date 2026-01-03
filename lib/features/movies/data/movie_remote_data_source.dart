import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class MovieRemoteDataSource {

  final String apiKey = 'dd5b273e783e966d89f5607f8bc77f15';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'),
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
        Uri.parse('$baseUrl/movie/$id?api_key=$apiKey'),
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
