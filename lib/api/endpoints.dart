import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EndPoint {
  static String _moviesList = 'https://yts.mx/api/v2/list_movies.json?';
  String _movieDetails = 'https://yts.mx/api/v2/movie_details.json';
  String _movieSuggestions = 'https://yts.mx/api/v2/movie_suggestions.json';
  String _movieComments = 'https://yts.mx/api/v2/movie_comments.json';
  String _movieReviews = 'https://yts.mx/api/v2/movie_reviews.json';
  static String _movieParentalGuides =
      'https://yts.mx/api/v2/movie_parental_guides.json';

  //this method refines the query by eliminating
  //keys having null value
  static String _parameterRefiner(Map<String, dynamic> map) {
    String _refined = '';
    map.forEach((key, value) {
      if (value != null) {
        _refined += key + '=' + value.toString() + '&';
      }
    });

    return _refined.substring(0, _refined.length - 1);
  }

  static Future moviesList(
      {int limit,
      int page,
      String quality,
      int minimumRating,
      String queryTerm,
      String genre,
      String sortBy,
      String orderBy,
      bool withRtRating}) async {
    Map<String, dynamic> _parameters = {
      'limit': limit,
      'page': page,
      'quality': quality,
      'minimum_rating': minimumRating,
      'query_term': queryTerm,
      'genre': genre,
      'sort_by': sortBy,
      'order_by': orderBy,
      'with_rt_rating': withRtRating
    };

    http.Response response;
    try {
      response = await http.get(_moviesList + _parameterRefiner(_parameters));
      return response;
    } on Exception catch (exception) {
      print(exception);
    } on Error catch (error) {
      print(error);
    }
  }

  //to get movie details by id
  
}
