import 'package:defect_tracking_system/screens/reviews/providers/Review.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewDetailScreen extends StatelessWidget {
  final String reviewId;

  ReviewDetailScreen({required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Details'),
      ),
      body: FutureBuilder(
        future: Provider.of<ReviewProvider>(context, listen: false)
            .fetchReviewDetails(reviewId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                Review? review = reviewProvider.selectedReview;
                if (review == null) {
                  return Center(child: Text('Review not found.'));
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        review.reviewText,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Likes: ${review.likes.length}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: review.reviewComments.length,
                          itemBuilder: (context, index) {
                            ReviewComment comment =
                                review.reviewComments[index];
                            return ListTile(
                              leading: Icon(Icons.comment),
                              title: Text(comment.name),
                              subtitle: Text(comment.text),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
