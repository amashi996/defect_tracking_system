import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch reviews when the profile page is loaded
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false).fetchReceivedReviews();
      Provider.of<ReviewProvider>(context, listen: false).fetchSentReviews();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false,
      pageTitle: const Text('User Profile'),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.person), text: 'My Profile'),
              Tab(icon: Icon(Icons.reviews), text: 'My Reviews'),
              Tab(icon: Icon(Icons.badge), text: 'My Badges'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyProfileTab(),
            MyReviewsTab(),
            MyBadgesTab(),
          ],
        ),
      ),
    );
  }
}

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: John Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: johndoe@example.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Member Since: January 2020', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  _MyReviewsTabState createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  int receivedPage = 1;
  int sentPage = 1;

  bool receivedExpanded = true;
  bool sentExpanded = false;

  @override
  Widget build(BuildContext context) {
    final receivedReviews = context.watch<ReviewProvider>().receivedReviews;
    final sentReviews = context.watch<ReviewProvider>().sentReviews;

    return ListView(
      children: [
        ExpansionTile(
          leading: Icon(Icons.reviews, color: receivedExpanded ? Colors.blue : Colors.black),
          title: Text(
            'Received Reviews',
            style: TextStyle(color: receivedExpanded ? Colors.blue : Colors.black),
          ),
          initiallyExpanded: receivedExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              receivedExpanded = expanded;
            });
          },
          children: [
            if (receivedReviews.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sorry, you did not receive any reviews from other users yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              PaginatedReviews(
                reviews: receivedReviews.map((review) => ReviewItem(
                  reviewerName: review.reviewerName,
                  reviewerEmail: review.reviewerEmail,
                  reviewerAvatar: review.reviewerAvatar,
                  reviewText: review.reviewText,
                )).toList(),
                currentPage: receivedPage,
                onPageChanged: (page) {
                  setState(() {
                    receivedPage = page;
                  });
                },
              ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.send, color: sentExpanded ? Colors.blue : Colors.black),
          title: Text(
            'Sent Reviews',
            style: TextStyle(color: sentExpanded ? Colors.blue : Colors.black),
          ),
          initiallyExpanded: sentExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              sentExpanded = expanded;
            });
          },
          children: [
            if (sentReviews.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Oops, you did not send any reviews for any user yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              PaginatedReviews(
                reviews: sentReviews.map((review) => ReviewItem(
                  reviewerName: review.reviewerName,
                  reviewerEmail: review.reviewerEmail,
                  reviewerAvatar: review.reviewerAvatar,
                  reviewText: review.reviewText,
                )).toList(),
                currentPage: sentPage,
                onPageChanged: (page) {
                  setState(() {
                    sentPage = page;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}

class PaginatedReviews extends StatelessWidget {
  final List<ReviewItem> reviews;
  final int currentPage;
  final Function(int) onPageChanged;

  const PaginatedReviews({
    super.key,
    required this.reviews,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    const int reviewsPerPage = 5;
    int totalPages = (reviews.length / reviewsPerPage).ceil();
    int startIndex = (currentPage - 1) * reviewsPerPage;
    int endIndex = (startIndex + reviewsPerPage).clamp(0, reviews.length);

    List<ReviewItem> currentReviews = reviews.sublist(startIndex, endIndex);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentReviews.length,
          itemBuilder: (context, index) {
            final review = currentReviews[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(review.reviewerAvatar),
              ),
              title: Text('${review.reviewerName} (${review.reviewerEmail})'),
              subtitle: Text(review.reviewText),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return GestureDetector(
                onTap: () {
                  onPageChanged(index + 1);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: currentPage == index + 1 ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class MyBadgesTab extends StatelessWidget {
  const MyBadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Currently Earned Badges',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BadgeWidget(
                icon: Icons.star,
                badgeName: 'Badge Name 1',
                badgeDescription: 'Badge Description 1',
              ),
              BadgeWidget(
                icon: Icons.check_circle,
                badgeName: 'Badge Name 2',
                badgeDescription: 'Badge Description 2',
              ),
              BadgeWidget(
                icon: Icons.speed,
                badgeName: 'Badge Name 3',
                badgeDescription: 'Badge Description 3',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final String badgeName;
  final String badgeDescription;

  const BadgeWidget({
    super.key,
    required this.icon,
    required this.badgeName,
    required this.badgeDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 50, color: Colors.blue),
        const SizedBox(height: 8),
        Text(badgeName, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(badgeDescription, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ReviewItem {
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerAvatar;
  final String reviewText;

  ReviewItem({
    required this.reviewerName,
    required this.reviewerEmail,
    required this.reviewerAvatar,
    required this.reviewText,
  });
}


