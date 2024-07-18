import 'package:defect_tracking_system/screens/reviews/providers/Review.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';

// class ReviewPage extends StatefulWidget {
//   const ReviewPage({super.key});

//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }

class ReviewsTabView extends StatelessWidget {
  const ReviewsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: Text('All reviews'),
      showBackButton: false,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.sentiment_satisfied), text: 'Given'),
                  Tab(icon: Icon(Icons.sentiment_neutral), text: 'Received'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReviewsList(reviews: getUserGivenReviews()),
                  ReviewsList(reviews: getUserReceivedReviews()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Review> getUserGivenReviews() {
  // Replace this with actual data fetching logic
  return [
    Review(reviewer: 'User A', content: 'Great job!', rating: 4.5),
    Review(reviewer: 'User B', content: 'Good work', rating: 4.0),
  ];
}

List<Review> getUserReceivedReviews() {
  // Replace this with actual data fetching logic
  return [
    Review(reviewer: 'User C', content: 'Well done!', rating: 5.0),
    Review(reviewer: 'User D', content: 'Nice effort', rating: 3.5),
  ];
}
