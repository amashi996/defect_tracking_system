import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';

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

class MyReviewsTab extends StatelessWidget {
  const MyReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: List.generate(
          10,
          (index) => ListTile(
            leading: const Icon(Icons.person),
            title: Text('Reviewer ${index + 1}'),
            subtitle: Text('This is a review from user ${index + 1}.'),
          ),
        ),
      ),
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

  const BadgeWidget(
      {super.key,
      required this.icon,
      required this.badgeName,
      required this.badgeDescription});

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
