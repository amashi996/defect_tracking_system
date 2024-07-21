import 'package:defect_tracking_system/screens/reviews/providers/Review.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/screens/reviews/review_detail_page.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: Text('Reviews'),
      showBackButton: false,
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          if (reviewProvider.reviews.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: reviewProvider.reviews.length,
            itemBuilder: (context, index) {
              Review review = reviewProvider.reviews[index];
              return ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(review.name),
                subtitle: Text(review.reviewText),
                trailing: Text(
                  '${review.likes.length} likes',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReviewDetailScreen(reviewId: review.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
