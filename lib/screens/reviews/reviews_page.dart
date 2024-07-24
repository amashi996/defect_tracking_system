import 'package:defect_tracking_system/screens/reviews/providers/review_model.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/screens/reviews/review_detail_page.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

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
      pageTitle: const Text('Reviews'),
      showBackButton: false,
      body: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => debugPrint('Add Review'),
          label: const Text('Add Review'),
          icon: const Icon(Icons.add),
        ),
        body: Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {
            if (reviewProvider.reviews.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: reviewProvider.reviews.length,
              itemBuilder: (context, index) {
                Review review = reviewProvider.reviews[index];
                return ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(review.reviewerName),
                  subtitle: Text(review.reviewText),
                  trailing: Text(
                    '${review.likes.length} likes',
                    style: const TextStyle(color: Colors.grey),
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
      ),
    );
  }
}