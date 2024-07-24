import 'dart:convert';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  List<Review> _receivedReviews = [];
  List<Review> _sentReviews = [];
  Review? _selectedReview;

  List<Review> get reviews => _reviews;
  List<Review> get receivedReviews => _receivedReviews;
  List<Review> get sentReviews => _sentReviews;
  Review? get selectedReview => _selectedReview;

  final String apiUrl = 'http://your-api-url.com/reviews';

  Future<void> fetchReviews() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getAllReviewsNoAuth),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> reviewList = jsonDecode(response.body);
      _reviews = reviewList.map((json) => Review.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> fetchReceivedReviews() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getAllMyRecReviews),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> reviewList = jsonDecode(response.body);
      _receivedReviews =
          reviewList.map((json) => Review.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load received reviews');
    }
  }

  Future<void> fetchSentReviews() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getAllMySentReviews),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> reviewList = jsonDecode(response.body);
      _sentReviews = reviewList.map((json) => Review.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load sent reviews');
    }
  }

  Future<void> fetchReviewDetails(String reviewId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getSingleReview(reviewId)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-auth-token': token!
      },
    );

    if (response.statusCode == 200) {
      _selectedReview = Review.fromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load review details');
    }
  }

  Future<void> addReview(Review review) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.post(
      Uri.parse(Urls.addReview + review.user),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      _reviews.add(Review.fromJson(jsonDecode(response.body)));
      notifyListeners();
    } else {
      throw Exception('Failed to add review');
    }
  }

  Future<void> updateReview(Review review) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${review.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 200) {
      int index = _reviews.indexWhere((r) => r.id == review.id);
      if (index != -1) {
        _reviews[index] = review;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update review');
    }
  }

  Future<void> deleteReview(String reviewId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$reviewId'));

    if (response.statusCode == 200) {
      _reviews.removeWhere((review) => review.id == reviewId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete review');
    }
  }
}
