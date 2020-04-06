class EndPoint {
  String _moviesList = 'https://yts.mx/api/v2/list_movies.json';
  String _movieDetails = 'https://yts.mx/api/v2/movie_details.json';
  String _movieSuggestions = 'https://yts.mx/api/v2/movie_suggestions.json';
  String _movieComments = 'https://yts.mx/api/v2/movie_comments.json';
  String _movieReviews = 'https://yts.mx/api/v2/movie_reviews.json';
  String _movieParentalGuides =
      'https://yts.mx/api/v2/movie_parental_guides.json';
  String upcomingList = 'https://yts.mx/api/v2/list_upcoming.json';

  static Future moviesList(
      {int limit,
      int page,
      String quality,
      int minimumRating,
      String queryTerm,
      String genre,
      String sortBy,
      String orderBy,
      bool withRtRating}) async {}
}

