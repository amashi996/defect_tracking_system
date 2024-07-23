import 'dart:convert';
import 'package:defect_tracking_system/constants/urls/urls.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  Review? _selectedReview;

  List<Review> get reviews => _reviews;
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

  Future<void> fetchReviewDetails(String reviewId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    final response = await http.get(
      Uri.parse(Urls.getSingleReview(reviewId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
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
      Uri.parse('$apiUrl/${review.user}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 200) {
      int index = _reviews.indexWhere((r) => r.user == review.user);
      if (index != -1) {
        _reviews[index] = review;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update review');
    }
  }

  Future<void> deleteReview(String userId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$userId'));

    if (response.statusCode == 200) {
      _reviews.removeWhere((review) => review.user == userId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete review');
    }
  }
}
