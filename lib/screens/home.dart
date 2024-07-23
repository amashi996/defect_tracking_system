import 'package:defect_tracking_system/screens/defects/providers/defect_provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_model.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchDefectsFuture;
  late Future<void> _fetchReviewsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDefectsFuture = Provider.of<DefectsProvider>(context, listen: false).fetchDefects();
    _fetchReviewsFuture = Provider.of<ReviewProvider>(context, listen: false).fetchReceivedReviews();
  }

  @override
  Widget build(BuildContext context) {
    final defectsProvider = Provider.of<DefectsProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return AppScaffold(
      pageTitle: const Text('Gamified Progress Tracking'),
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.purple[100],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Badges',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.star, size: 40.0, color: Colors.amber),
                            Icon(Icons.verified, size: 40.0, color: Colors.blue),
                            Icon(Icons.check_circle, size: 40.0, color: Colors.green),
                            Icon(Icons.shield, size: 40.0, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Received Recent Reviews',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        FutureBuilder(
                          future: _fetchReviewsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (reviewProvider.receivedReviews.isEmpty) {
                                return const Center(child: Text('No reviews received.'));
                              } else {
                                final reviews = reviewProvider.receivedReviews.take(2).toList();

                                return Column(
                                  children: reviews.map((review) {
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.person),
                                        subtitle: Text(review.reviewText ?? 'No Description'),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/all-reviews');
                            },
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Defects',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  FutureBuilder(
                    future: _fetchDefectsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (defectsProvider.defects.isEmpty) {
                          return const Center(child: Text('No defects found.'));
                        }
                        // Sort defects by creation date and take the latest 5
                        final recentDefects = defectsProvider.defects
                            .where((defect) => defect.modifiedDate != null)
                            .toList()
                            ..sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
                        final latestFiveDefects = recentDefects.take(5).toList();

                        return DataTable(
                          columns: const [
                            DataColumn(label: Text('Defect ID')),
                            DataColumn(label: Text('Defect Title')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Assignee')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: latestFiveDefects.map((defect) {
                            return DataRow(cells: [
                              DataCell(Text(defect.id)),
                              DataCell(Text(defect.defectTitle)),
                              DataCell(Text(defect.defectStatus)),
                              DataCell(Text(defect.assignedTo)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/all-defects');
                      },
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:defect_tracking_system/screens/defects/providers/defect_provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/screens/user/providers/user_provider.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchDefectsFuture;
  late Future<void> _fetchReviewsFuture;
  late Future<void> _fetchUserBadgesFuture;

  @override
  void initState() {
    super.initState();
    _fetchDefectsFuture = Provider.of<DefectsProvider>(context, listen: false).fetchDefects();
    _fetchReviewsFuture = Provider.of<ReviewProvider>(context, listen: false).fetchReceivedReviews();
    _fetchUserBadgesFuture = Provider.of<UserProvider>(context, listen: false).fetchUserBadges();
  }

  @override
  Widget build(BuildContext context) {
    final defectsProvider = Provider.of<DefectsProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return AppScaffold(
      pageTitle: const Text('Gamified Progress Tracking'),
      showBackButton: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.purple[100],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Badges',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        FutureBuilder(
                          future: _fetchUserBadgesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (userProvider.badges.isEmpty) {
                                return const Center(child: Text('No badges earned.'));
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: userProvider.badges.take(4).map((badgeUrl) {
                                    return Image.network(badgeUrl, height: 40.0, width: 40.0);
                                  }).toList(),
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Received Recent Reviews',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        FutureBuilder(
                          future: _fetchReviewsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              if (reviewProvider.receivedReviews.isEmpty) {
                                return const Center(child: Text('No reviews received.'));
                              } else {
                                final reviews = reviewProvider.receivedReviews.take(2).toList();

                                return Column(
                                  children: reviews.map((review) {
                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.person),
                                        subtitle: Text(review.reviewText ?? 'No Description'),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/all-reviews');
                            },
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Defects',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  FutureBuilder(
                    future: _fetchDefectsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (defectsProvider.defects.isEmpty) {
                          return const Center(child: Text('No defects found.'));
                        }
                        // Sort defects by creation date and take the latest 5
                        final recentDefects = defectsProvider.defects
                            .where((defect) => defect.modifiedDate != null)
                            .toList()
                            ..sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
                        final latestFiveDefects = recentDefects.take(5).toList();

                        return DataTable(
                          columns: const [
                            DataColumn(label: Text('Defect ID')),
                            DataColumn(label: Text('Defect Title')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Assignee')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: latestFiveDefects.map((defect) {
                            return DataRow(cells: [
                              DataCell(Text(defect.id)),
                              DataCell(Text(defect.defectTitle)),
                              DataCell(Text(defect.defectStatus)),
                              DataCell(Text(defect.assignedTo)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/all-defects');
                      },
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/





