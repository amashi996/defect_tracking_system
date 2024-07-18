class Urls {
  //static const String baseUrl = 'https://wioms-backend.onrender.com';
  static const String baseUrl = 'http://localhost:5001';
  static const String getAllProducts = '$baseUrl/api/products/get/all';

  static const String loginUser = '$baseUrl/api/auth';

  // static String getSingle(String productId) {
  //   return baseUrl + '/api/products/get/single/' + productId.toString();
  // }
}
