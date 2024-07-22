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
}
