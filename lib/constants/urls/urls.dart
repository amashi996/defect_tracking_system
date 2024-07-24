class Urls {
  //static const String baseUrl = 'https://wioms-backend.onrender.com';
  static const String baseUrl = 'http://localhost:5001';
  static const String getAllProducts = '$baseUrl/api/products/get/all';

  static const String loginUser = '$baseUrl/api/auth';
  static const String getProfileDetails = '$baseUrl/api/profile/me';

  static const String getAllReviewsNoAuth = '$baseUrl/api/reviews';
  static String getSingleReview(String reviewId) {
    return '$baseUrl/api/reviews/$reviewId';
  }

  static const String getLeaderBoard = '$baseUrl/api/leaderboard';
  static const String getAllUsers = '$baseUrl/api/auth/users';
  static const String addReview = '$baseUrl/api/reviews/addRev/';

  static const String getAllMyRecReviews = '$baseUrl/api/reviews/received';
  static const String getAllMySentReviews = '$baseUrl/api/reviews/added';
  static const String getAllDefects = '$baseUrl/api/defects/allDefects';
}
